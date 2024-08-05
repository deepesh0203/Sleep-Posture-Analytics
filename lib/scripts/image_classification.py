import os
import sys
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from tensorflow.keras.models import model_from_json
from tensorflow.keras.preprocessing.image import load_img, img_to_array

def predict_class(img_array, model):
    prediction = model.predict(img_array)
    predicted_class = np.argmax(prediction, axis=1)[0]
    return predicted_class

if __name__ == "__main__":
    try:
        # Load model
        with open(r"C:\Users\deepe\sleep_posture_classification\lib\scripts\image_classification_model.json", 'r') as json_file:
            loaded_model_json = json_file.read()
        loaded_model = model_from_json(loaded_model_json)
        loaded_model.load_weights(r"C:\Users\deepe\sleep_posture_classification\lib\scripts\image_classification_model_weights.h5")
        loaded_model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

        # Load text file and generate image
        SECOND = 30
        file_path = sys.argv[1]

        df = pd.read_csv(file_path, sep='\t', header=None).iloc[:, :-1]
        sub = df.iloc[SECOND].values.reshape(64, 32)

        # Plot heatmap
        plt.figure(figsize=(6, 12), dpi=300)  # Increased DPI for higher quality
        sns.heatmap(sub, vmin=0, vmax=1000, cmap='magma', cbar=False, annot=False, xticklabels=False, yticklabels=False)
        img_save_path = 'tmp/generated_image.png'
        if os.path.exists(img_save_path):
            os.remove(img_save_path)
        plt.axis('off')  # Turn off the axis
        plt.savefig(img_save_path, bbox_inches='tight', pad_inches=0)  # No extra whitespace
        plt.close()

        # Load generated image for classification
        img = load_img(img_save_path, target_size=(32, 64))
        img_array = img_to_array(img)
        img_array = np.expand_dims(img_array, axis=0)
        img_array /= 255.0

        # Predict class
        predicted_class_index = predict_class(img_array, loaded_model)
        class_names = {4: 'Supine', 0: 'Left', 2:'Right',1:'Left Fetus',3:'Right Fetus'}
        predicted_class_name = class_names[predicted_class_index]
        print("Predicted class:", predicted_class_name)
        print("Image path:", img_save_path)
    except Exception as e:
        print(f"Error: {e}")
    sys.stdout.flush()
