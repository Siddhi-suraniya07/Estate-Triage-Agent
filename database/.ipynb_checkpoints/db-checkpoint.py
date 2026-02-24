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
    if not entities:
        return

    conn = get_db_connection()
    cursor = conn.cursor()
    
    query = "INSERT INTO extracted_entities (ticket_id, entity_type, entity_value) VALUES (%s, %s, %s)"
    
    try:
        for entity in entities:
            # Check if entity has correct keys
            if 'type' in entity and 'value' in entity:
                cursor.execute(query, (ticket_id, entity['type'], entity['value']))
            else:
                print(f"⚠️ Skipping invalid entity format: {entity}")
        
        conn.commit()
        print(f"✅ Saved {len(entities)} entities for {ticket_id}")
    except Exception as e:
        print(f"❌ Database Error saving entities: {e}")
    finally:
        cursor.close()
        conn.close()

def update_ticket_status(ticket_id, new_status):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE support_tickets SET status = %s WHERE ticket_id = %s", (new_status, ticket_id))
    conn.commit()
    conn.close()

# NEW: Get Statistics for Dashboard
def get_dashboard_stats():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    stats = {}
    
    cursor.execute("SELECT COUNT(*) as total FROM support_tickets")
    stats['total'] = cursor.fetchone()['total']
    
    cursor.execute("SELECT COUNT(*) as total FROM support_tickets WHERE status='open'")
    stats['open'] = cursor.fetchone()['total']
    
    cursor.execute("SELECT COUNT(*) as total FROM support_tickets WHERE urgency='high' AND status='open'")
    stats['urgent'] = cursor.fetchone()['total']
    
    cursor.execute("SELECT COUNT(*) as total FROM support_tickets WHERE category='maintenance_urgent'")
    stats['maintenance'] = cursor.fetchone()['total']
    
    conn.close()
    return stats