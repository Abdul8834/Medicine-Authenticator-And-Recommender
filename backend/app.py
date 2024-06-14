from flask import Flask, render_template, request, redirect, url_for
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Load the dataset
df = pd.read_csv("medicine.csv")
app = Flask(__name__)


def find_alternative_medicines(input_reason_description, df):
    # Calculate TF-IDF vectors for all medicines using both reason and description
    tfidf_vectorizer = TfidfVectorizer(stop_words='english')
    tfidf_matrix = tfidf_vectorizer.fit_transform(df['Reason'] + ' ' + df['Description'])
    
    # Calculate cosine similarity between input reason/description and all medicines
    input_tfidf = tfidf_vectorizer.transform([input_reason_description])
    similarities = cosine_similarity(input_tfidf, tfidf_matrix)
    
    # Get indices of medicines with highest similarity scores
    top_indices = similarities.argsort()[0][-6:-1][::-1]
    
    # Get similarity scores for top similar medicines
    similarity_scores = similarities[0][top_indices]
    
    # Return names of top similar medicines and their similarity scores
    top_medicines = df.iloc[top_indices][['Drug_Name', 'Reason', 'Description']]
    top_medicines['Similarity_Score'] = similarity_scores
    
    return top_medicines
@app.route('/result', methods=['GET', 'POST'])  
def contact():
    if request.method == 'POST':
        text = request.form['reason']
        res= find_alternative_medicines(text, df)
        print(res)
        dic={}
        dic["res"]=res.to_dict(orient='records')
        return dic


if __name__ == '__main__':
    app.run(debug=True)