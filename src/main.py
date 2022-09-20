import coremltools as ct
import tensorflow as tf
from PIL import Image, ImageOps

FILE_NAME = 'assets/banana2.jpg'
class_labels = ['banana', 'human']

img = tf.keras.utils.load_img(
    FILE_NAME, target_size=(256, 256), color_mode='grayscale'
)
img_array = tf.keras.utils.img_to_array(img)
img_array = tf.expand_dims(img_array, 0)

model = tf.keras.models.load_model('model')
predictions = model.predict(img_array)
print(predictions)


image_input = ct.ImageType(shape=(1, 256, 256, 1), color_layout='G')
classifier_config = ct.ClassifierConfig(class_labels=class_labels)
mlmodel = ct.convert(model, source="tensorflow", inputs=[image_input], classifier_config=classifier_config)
mlmodel.save('bananaModel.mlmodel')

exImage = Image.open(FILE_NAME).resize((256, 256))
exImage = ImageOps.grayscale(exImage)
out_dict = mlmodel.predict({'sequential_input': exImage})
print(out_dict)
