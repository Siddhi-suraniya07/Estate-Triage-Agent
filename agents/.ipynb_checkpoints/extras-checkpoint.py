import os
from dotenv import load_dotenv
from langchain_groq import ChatGroq
from langchain_core.prompts import PromptTemplate

load_dotenv()

llm = ChatGroq(
    model="llama-3.3-70b-versatile",
    temperature=0,
    groq_api_key=os.getenv("GROQ_API_KEY")
)

# --- AGENT 3: SENTIMENT ANALYZER ---
sentiment_template = """
Analyze the sentiment of this tenant message.
Return ONLY one word: [POSITIVE, NEUTRAL, NEGATIVE, ANGRY].

Message: "{message}"
"""
sentiment_prompt = PromptTemplate(input_variables=["message"], template=sentiment_template)

def analyze_sentiment(message):
    chain = sentiment_prompt | llm
    return chain.invoke({"message": message}).content.strip().upper()

# --- AGENT 4: SUMMARIZER ---
summary_template = """
Write a very short 5-8 word summary of this issue for a dashboard view.
Example: "Leaking sink in kitchen"
Message: "{message}"
"""
summary_prompt = PromptTemplate(input_variables=["message"], template=summary_template)

def generate_summary(message):
    chain = summary_prompt | llm
    return chain.invoke({"message": message}).content.strip()