import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv('DB_HOST'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        database=os.getenv('DB_NAME')
    )

# --- CORRECTED INIT FUNCTION ---
def init_db():
    """Checks if database has new columns and adds them safely."""
    print("🔄 Checking Database Structure...")
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # 1. Try Adding 'sentiment' column
    try:
        cursor.execute("ALTER TABLE support_tickets ADD COLUMN sentiment VARCHAR(20) DEFAULT 'Neutral'")
        print("✅ Added 'sentiment' column.")
    except mysql.connector.Error as err:
        # Error 1060 means "Duplicate column name" (It already exists)
        if err.errno == 1060:
            pass # Column exists, do nothing
        else:
            print(f"⚠️ Warning checking sentiment: {err}")

    # 2. Try Adding 'summary' column
    try:
        cursor.execute("ALTER TABLE support_tickets ADD COLUMN summary VARCHAR(255) DEFAULT 'No summary available'")
        print("✅ Added 'summary' column.")
    except mysql.connector.Error as err:
        if err.errno == 1060:
            pass # Column exists, do nothing
        else:
            print(f"⚠️ Warning checking summary: {err}")

    conn.commit()
    cursor.close()
    conn.close()
    print("🚀 Database Ready.")

# --- Existing Functions (Unchanged) ---

def get_all_tickets():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM support_tickets ORDER BY created_at DESC")
    tickets = cursor.fetchall()
    conn.close()
    return tickets

def get_ticket_details(ticket_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM support_tickets WHERE ticket_id = %s", (ticket_id,))
    ticket = cursor.fetchone()
    if ticket:
        cursor.execute("SELECT draft_text FROM draft_responses WHERE ticket_id = %s ORDER BY id DESC LIMIT 1", (ticket_id,))
        draft = cursor.fetchone()
        ticket['draft_response'] = draft['draft_text'] if draft else "No draft generated."
        
        cursor.execute("SELECT entity_type, entity_value FROM extracted_entities WHERE ticket_id = %s", (ticket_id,))
        ticket['entities'] = cursor.fetchall()
    conn.close()
    return ticket

def create_ticket(data):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = """
    INSERT INTO support_tickets 
    (ticket_id, sender_name, sender_email, unit_number, subject, message, category, urgency, sentiment, summary, status)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 'open')
    """
    cursor.execute(query, (
        data['ticket_id'], data['sender_name'], data['sender_email'],
        data['unit_number'], data['subject'], data['message'],
        data['category'], data['urgency'], 
        data.get('sentiment', 'Neutral'), data.get('summary', '...'),
    ))
    conn.commit()
    conn.close()

def save_draft_response(ticket_id, draft_text):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO draft_responses (ticket_id, draft_text, model_used) VALUES (%s, %s, 'llama3')", (ticket_id, draft_text))
    conn.commit()
    conn.close()

def save_entities(ticket_id, entities):
    if not entities: return
    conn = get_db_connection()
    cursor = conn.cursor()
    for entity in entities:
        cursor.execute("INSERT INTO extracted_entities (ticket_id, entity_type, entity_value) VALUES (%s, %s, %s)", (ticket_id, entity['type'], entity['value']))
    conn.commit()
    conn.close()

def update_ticket_status(ticket_id, new_status):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE support_tickets SET status = %s WHERE ticket_id = %s", (new_status, ticket_id))
    conn.commit()
    conn.close()

def get_dashboard_stats():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Initialize defaults in case DB is empty
    stats = {'total': 0, 'open': 0, 'urgent': 0, 'maintenance': 0}
    
    try:
        cursor.execute("SELECT COUNT(*) as total FROM support_tickets")
        res = cursor.fetchone()
        if res: stats['total'] = res['total']
        
        cursor.execute("SELECT COUNT(*) as total FROM support_tickets WHERE status='open'")
        res = cursor.fetchone()
        if res: stats['open'] = res['total']
        
        cursor.execute("SELECT COUNT(*) as total FROM support_tickets WHERE urgency='high' AND status='open'")
        res = cursor.fetchone()
        if res: stats['urgent'] = res['total']
        
        cursor.execute("SELECT COUNT(*) as total FROM support_tickets WHERE category='maintenance_urgent'")
        res = cursor.fetchone()
        if res: stats['maintenance'] = res['total']
        
    except Exception as e:
        print(f"Stats Error: {e}")
        
    conn.close()
    return stats