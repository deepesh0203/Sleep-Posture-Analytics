# video_classificationLSTM.py

import cv2
import numpy as np
from keras.models import model_from_json
import sys

def classify_video(video_path):
    posture = {'Left': 0, 'Left Fetus': 1, 'Right': 2, 'Right Fetus': 3, 'Supine': 4}
    
    # Load model
    with open("lib/scripts/Video_with_CNNLSTM.json", 'r') as json_file:
        loaded_model_json = json_file.read()
    loaded_model = model_from_json(loaded_model_json)
    loaded_model.load_weights("lib/scripts/Video_with_CNNLSTM_weights.h5")

    # Function to preprocess frame
    def preprocess_frame(frame, target_size=(32, 64)):
        frame_resized = cv2.resize(frame, target_size)
        frame_array = frame_resized.astype(np.float32) / 255.0
        return frame_array

    # Function to extract frames from a video
    def extract_frames(video_path, frame_shape=(64, 32)):
        frames = []
        cap = cv2.VideoCapture(video_path)
        while True:
            ret, frame = cap.read()
            if not ret:
                break
            frame = cv2.resize(frame, frame_shape)
            frames.append(preprocess_frame(frame))
            
        cap.release()
        return np.array(frames)

    # Extract frames from the video
    video_frames = extract_frames(video_path)

    # Preprocess the frames
    video_frames = video_frames.reshape(-1, 1, 64, 32, 3)

    # Predict posture using the model
    predictions = loaded_model.predict(video_frames)
    predicted_labels = np.argmax(predictions, axis=1)
    predicted_postures = [list(posture.keys())[label] for label in predicted_labels]    
    return predicted_postures

if __name__ == "__main__":
    video_path = sys.argv[1]  # Get video file path from command-line argument
    predicted_postures = classify_video(video_path)
    print(predicted_postures)
