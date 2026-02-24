import os
import json
from dotenv import load_dotenv

# Make sure you installed: pip install langchain-groq
from langchain_groq import ChatGroq
from langchain_core.prompts import PromptTemplate

load_dotenv()

# 1️⃣ Initialize Groq LLM
llm = ChatGroq(
    model="llama-3.3-70b-versatile",
    temperature=0,
    groq_api_key=os.getenv("GROQ_API_KEY")
)

# 2️⃣ Define Prompt Template
classification_template = """
You are an expert Real Estate Support Agent. 
Analyze the following incoming tenant message and extract the following information in JSON format:

1. "category": One of [maintenance_urgent, maintenance_normal, lease_inquiry, payment_issue, complaint, general_inquiry]
2. "urgency": One of [high, medium, low]
3. "summary": A 5-word summary of the issue.
4. "suggested_reply": A professional, empathetic draft response (max 2 sentences).

Incoming Message:
"{message}"

Return ONLY valid JSON. Do not include "Here is the JSON" or markdown ticks if possible.
"""

prompt = PromptTemplate(
    input_variables=["message"],
    template=classification_template
)

# 3️⃣ Classification Function
def classify_ticket(message_text):
    """
    Sends text to Groq LLM and returns classification dictionary.
    """
    # Create the chain
    chain = prompt | llm

    # Run the chain
    response = chain.invoke({"message": message_text})
    content = response.content.strip()

    # --- CLEANUP LOGIC (Crucial for Llama 3) ---
    # Sometimes Llama3 wraps code in ```json ... ```
    if "```json" in content:
        content = content.split("```json")[1].split("```")[0].strip()
    elif "```" in content:
        content = content.split("```")[1].strip()
    
    # Attempt to parse JSON
    try:
        data = json.loads(content)
        return data
    except json.JSONDecodeError:
        print(f"JSON Error. Raw content was: {content}") # Debugging
        return {
            "category": "general_inquiry",
            "urgency": "medium",
            "summary": "Error parsing AI response",
            "suggested_reply": "Thank you for your message. We will review it shortly."
        }