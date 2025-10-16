from flask import Flask, request, jsonify
from flask_cors import CORS
import csv

app = Flask(__name__)
CORS(app)

@app.route('/submit', methods=['POST'])
def submit():
    data = request.form
    with open('/Users/clare/hoffman_mount/bids_data/derivatives/fmriprep-23.1.3/qa/reviewer1_ir_fmriprep_qa.csv', 'a', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([data.get('Reviewer'), data.get('ImagePath'), data.get('Decision'), data.get('Note'), data.get('SubjectID')])
    return jsonify({"status": "success"})

if __name__ == '__main__':
    app.run(port=5001)  # Run Flask app on port 5001
