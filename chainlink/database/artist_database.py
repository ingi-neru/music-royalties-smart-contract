import logging
from flask import Flask, request, jsonify, Response
app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

import logging
import random
from flask import Flask, request, jsonify

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize a dictionary to store artists and their stream counts
artists_streams = {}

@app.route('/artist/<string:artist_name>', methods=['GET'])
def get_or_update_artist(artist_name):
    """
    Handle GET requests to fetch or update an artist's streams.
    If the artist does not exist, add them with a random number of streams.
    If the artist exists, increment their streams with a random value.
    """
    global artists_streams

    if artist_name not in artists_streams:
        # Generate a random number of streams for a new artist
        initial_streams = random.randint(1000, 10000)
        artists_streams[artist_name] = initial_streams
        logger.info(f"Added new artist '{artist_name}' with {initial_streams} streams.")
    else:
        # Increment existing artist's streams with a random value
        increment = random.randint(100, 1000)
        artists_streams[artist_name] += increment
        logger.info(f"Updated artist '{artist_name}' with {increment} additional streams.")

    # Return the artist's stream count as JSON
    return jsonify({"artist": artist_name, "streams": artists_streams[artist_name]})

if __name__ == '__main__':
    app.run(debug=True)
