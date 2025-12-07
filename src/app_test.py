import os
import sys
import pytest

# Ensure src/ is importable
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
sys.path.insert(0, ROOT)

from main import app  # src/main.py

@pytest.fixture
def client():
    app.config["TESTING"] = True
    return app.test_client()

def test_home_status_code(client):
    resp = client.get("/")
    assert resp.status_code == 200

def test_home_content(client):
    resp = client.get("/")
    assert b"Welcome to the 2048 Flask App!" in resp.data