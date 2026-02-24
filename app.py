from flask import Flask, render_template, request, redirect, url_for
from database.db import get_all_tickets, get_ticket_details, create_ticket, save_draft_response, save_entities, update_ticket_status, get_dashboard_stats
from agents.classifier import classify_ticket
from agents.ner import extract_entities
from agents.extras import analyze_sentiment, generate_summary  # <--- NEW IMPORT
import random

app = Flask(__name__)

@app.route('/')
def dashboard():
    tickets = get_all_tickets()
    stats = get_dashboard_stats() # <--- NEW STATS
    return render_template('dashboard.html', tickets=tickets, stats=stats)

@app.route('/submit', methods=['GET', 'POST'])
def submit_ticket():
    if request.method == 'GET':
        return render_template('submit_ticket.html')
    
    # POST Logic
    sender_name = request.form.get('sender_name')
    unit_number = request.form.get('unit_number')
    subject = request.form.get('subject')
    message = request.form.get('message')
    ticket_id = f"TKT-{random.randint(20000, 99999)}"

    # --- AI PIPELINE START ---
    print(f"🧠 AI Processing: {ticket_id}")
    
    # 1. Classification (Urgency/Intent)
    classification = classify_ticket(message)
    
    # 2. Entity Extraction
    entities = extract_entities(message)
    
    # 3. Sentiment Analysis (NEW)
    sentiment = analyze_sentiment(message)
    
    # 4. Summarization (NEW)
    summary = generate_summary(message)
    # --- AI PIPELINE END ---

    # Save Main Ticket
    ticket_data = {
        'ticket_id': ticket_id,
        'sender_name': sender_name,
        'sender_email': f"{sender_name.replace(' ', '.').lower()}@example.com",
        'unit_number': unit_number,
        'subject': subject,
        'message': message,
        'category': classification.get('category', 'general_inquiry'),
        'urgency': classification.get('urgency', 'medium'),
        'sentiment': sentiment, # <--- NEW
        'summary': summary      # <--- NEW
    }
    create_ticket(ticket_data)

    # Save Draft & Entities
    if 'suggested_reply' in classification:
        save_draft_response(ticket_id, classification['suggested_reply'])
    
    save_entities(ticket_id, entities)

    return redirect(url_for('dashboard'))

@app.route('/ticket/<ticket_id>')
def view_ticket(ticket_id):
    ticket = get_ticket_details(ticket_id)
    return render_template('ticket_detail.html', ticket=ticket)

@app.route('/resolve/<ticket_id>', methods=['POST'])
def resolve_ticket(ticket_id):
    update_ticket_status(ticket_id, 'resolved')
    return redirect(url_for('dashboard'))

if __name__ == '__main__':
    app.run(debug=True, port=5000)