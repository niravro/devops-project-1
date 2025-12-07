from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "GITOPS is successful with ARGOCD! Welcome to the 2048 Flask App!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)