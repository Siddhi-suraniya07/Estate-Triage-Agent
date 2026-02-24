import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

def update_schema():
    conn = mysql.connector.connect(
        host=os.getenv('DB_HOST'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        database=os.getenv('DB_NAME')
    )
    cursor = conn.cursor()
    
    print("🚀 Updating Database Schema...")

    try:
        # Add sentiment column
        cursor.execute("ALTER TABLE support_tickets ADD COLUMN sentiment VARCHAR(20) DEFAULT 'Neutral'")
        print("✅ Added 'sentiment' column.")
    except mysql.connector.Error as err:
        print(f"⚠️ Sentiment column might already exist: {err}")

    try:
        # Add summary column
        cursor.execute("ALTER TABLE support_tickets ADD COLUMN summary VARCHAR(255) DEFAULT 'No summary available'")
        print("✅ Added 'summary' column.")
    except mysql.connector.Error as err:
        print(f"⚠️ Summary column might already exist: {err}")

    conn.close()
    print("🎉 Database Update Complete!")

if __name__ == "__main__":
    update_schema()