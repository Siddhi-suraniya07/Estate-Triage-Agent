from flask import Flask, render_template, request, redirect, url_for, session
# from database.db import get_all_tickets, get_ticket_details, create_ticket, save_draft_response, save_entities, update_ticket_status, get_dashboard_stats, init_db
from agents.classifier import classify_ticket
from agents.ner import extract_entities
from agents.extras import analyze_sentiment, generate_summary
import random

app = Flask(__name__)
app.secret_key = 'super_secret_key_for_demo'

# --- RUN DB CHECK ON STARTUP ---
with app.app_context():
    pass
    # init_db()
# -------------------------------

# --- 1. LOGIN ROUTE ---
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        if username == 'admin' and password == '1234':
            session['role'] = 'manager'
            return redirect(url_for('dashboard'))
        elif username == 'tenant' and password == '1234':
            session['role'] = 'tenant'
            return redirect(url_for('submit_ticket'))
        else:
            return "Invalid credentials. Try again."
            
    return render_template('login.html')

# --- 2. LOGOUT ROUTE ---
@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

# --- 3. PROTECTED DASHBOARD ---
@app.route('/')
def dashboard():
    if 'role' not in session:
        return redirect(url_for('login'))
    
    if session['role'] == 'tenant':
        return redirect(url_for('submit_ticket'))

    # Dummy data instead of DB
    tickets = []
    stats = {"total": 0, "resolved": 0, "pending": 0}

    return render_template('dashboard.html', tickets=tickets, stats=stats)

# --- 4. SUBMIT ROUTE ---
@app.route('/submit', methods=['GET', 'POST'])
def submit_ticket():
    if 'role' not in session:
        return redirect(url_for('login'))

    if request.method == 'GET':
        return render_template('submit_ticket.html')
    
    sender_name = request.form.get('sender_name')
    unit_number = request.form.get('unit_number')
    subject = request.form.get('subject')
    message = request.form.get('message')
    ticket_id = f"TKT-{random.randint(20000, 99999)}"

    # AI Pipeline
    classification = classify_ticket(message)
    entities = extract_entities(message)
    sentiment = analyze_sentiment(message)
    summary = generate_summary(message)

    # Dummy save (NO DB)
    ticket_data = {
        'ticket_id': ticket_id,
        'sender_name': sender_name,
        'unit_number': unit_number,
        'subject': subject,
        'message': message,
        'category': classification.get('category', 'general_inquiry'),
        'urgency': classification.get('urgency', 'medium'),
        'sentiment': sentiment,
        'summary': summary
    }

    # create_ticket(ticket_data)
    # save_draft_response(ticket_id, classification.get('suggested_reply', ''))
    # save_entities(ticket_id, entities)

    if session['role'] == 'manager':
        return redirect(url_for('dashboard'))
    else:
        return "<h3>Ticket Submitted Successfully! <a href='/logout'>Logout</a></h3>"

@app.route('/ticket/<ticket_id>')
def view_ticket(ticket_id):
    if 'role' not in session or session['role'] != 'manager':
        return redirect(url_for('login'))

    # Dummy ticket
    ticket = {
        "ticket_id": ticket_id,
        "message": "Demo ticket",
        "status": "pending"
    }

    return render_template('ticket_detail.html', ticket=ticket)

@app.route('/resolve/<ticket_id>', methods=['POST'])
def resolve_ticket(ticket_id):
    if 'role' not in session or session['role'] != 'manager':
        return redirect(url_for('login'))

    # update_ticket_status(ticket_id, 'resolved')
    return redirect(url_for('dashboard'))

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True, port=5000)