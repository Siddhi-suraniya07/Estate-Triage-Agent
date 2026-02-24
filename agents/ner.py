import os
import json
import re
from dotenv import load_dotenv
from langchain_groq import ChatGroq
from langchain_core.prompts import PromptTemplate

load_dotenv()

llm = ChatGroq(
    model="llama-3.3-70b-versatile",
    temperature=0,
    groq_api_key=os.getenv("GROQ_API_KEY")
)

# NOTICE: The prompt specifically asks for "Contextual Labels"
ner_template = """
You are an expert Data Extraction AI.
Analyze the message and extract key data points.

Instead of generic categories like "DATE" or "MONEY", assign a **Short Descriptive Label** based on context.

Rules:
1. Extract Dates, Money, Unit Numbers.
2. The "type" MUST be specific (e.g., "Move-out Date", "Security Deposit", "Refund Deadline").
3. Format as a JSON array.

Input Message:
"{message}"

Return ONLY valid JSON.
Example Output:
[
  {{"type": "Unit Number", "value": "2A-109"}},
  {{"type": "Move-out Date", "value": "31/01/2026"}},
  {{"type": "Security Deposit", "value": "₹25,000"}}
]

If no data found, return [].
"""

prompt = PromptTemplate(
    input_variables=["message"],
    template=ner_template
)

def extract_entities(message_text):
    chain = prompt | llm
    try:
        response = chain.invoke({"message": message_text})
        content = response.content.strip()

        if "```" in content:
            match = re.search(r"```(?:json)?(.*?)```", content, re.DOTALL)
            if match:
                content = match.group(1).strip()
        
        data = json.loads(content)
        if isinstance(data, list):
            return data
        else:
            return []
    except Exception as e:
        print(f"❌ NER Error: {e}")
        return []