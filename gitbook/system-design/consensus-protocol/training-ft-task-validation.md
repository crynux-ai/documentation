# Training/FT Task Validation

## Stable Diffusion Model Fine-tuning

The SD model fine-tuning task could be executed using a combination of all types of GPU models.

Rather than directly validating the result models, multiple images are produced using the models and a random prompt (seed) provided by the blockchain. [The method](https://docs.crynux.ai/system-design/consensus-protocol/inference-task-validation#stable-diffusion-image-generation) for validating image generation tasks is applied to assess the similarity between images created by two models.

The average similarity score of these images serves as the measure of similarity between the two models. And models with the similarity score under a given threshold is considered the same model.



