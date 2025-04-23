import time
import torch
import torch.nn as nn
.pytorch
import numpy as np
import pandas as pd
from sklearn.datasets import make_circles
from sklearn.model_selection import train_test_split
from mlflow.models.signature import infer_signature
from mlflow.data import from_pandas

# 1. Define a simple PyTorch model
class CircleModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(2, 16)
        self.fc2 = nn.Linear(16, 1)

    def forward(self, x):
        x = torch.relu(self.fc1(x))
        return self.fc2(x)

# 2. Generate synthetic data (2D binary classification)
X, y = make_circles(n_samples=1000, noise=0.1, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

X_train_tensor = torch.tensor(X_train, dtype=torch.float32)
y_train_tensor = torch.tensor(y_train, dtype=torch.float32).unsqueeze(1)

# 3. Minimal training setup
model = CircleModel()
loss_fn = nn.BCEWithLogitsLoss()
optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
epochs = 10

# 4. Prepare a small dataset sample for MLflow logging
df_sample = pd.DataFrame({
    "X_0": X_train[:5, 0],
    "X_1": X_train[:5, 1],
    "y": y_train[:5],
})

# 5. Track experiment with MLflow
mlflow.set_experiment("minimal_pytorch_demo")
start_time = time.time()

with mlflow.start_run():
    # --- Log Parameters ---
    mlflow.log_param("learning_rate", 0.01)
    mlflow.log_param("epochs", epochs)
    mlflow.log_param("loss_fn", "BCEWithLogitsLoss")
    mlflow.log_param("optimizer", "SGD")

    # --- Training Loop ---
    for epoch in range(epochs):
        model.train()
        y_pred = model(X_train_tensor)
        loss = loss_fn(y_pred, y_train_tensor)

        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        mlflow.log_metric("train_loss", loss.item(), step=epoch)

    # --- Sample Data Logging ---
    mlflow.log_input(from_pandas(df_sample, targets="y", name="circle_sample"))

    # --- Model Metadata ---
    input_example = X_train_tensor[:1].detach().cpu().numpy()
    y_example = model(torch.from_numpy(input_example)).detach().cpu().numpy()
    signature = infer_signature(input_example, y_example)

    # --- Log Model ---
.pytorch.log_model(
        model,
        artifact_path="model",
        input_example=input_example,
        signature=signature
    )

    elapsed = time.time() - start_time
    mlflow.log_metric("train_duration_sec", elapsed)

    print(f"✅ Training complete. Logged to MLflow in {elapsed:.2f} seconds.")
