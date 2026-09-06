#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Get the absolute path of the directory where the script resides.
# This makes the script runnable from any location.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Define the list of models to be verified
MODELS_TO_VERIFY=(
    "A23B1D1E1G1"
    "A23B1D1E1G2H1J1"
    "A23B1D1E1G2H1J1K1"
    "A23B1D1E1G2H1J2"
    "A23B1D1E1G2I2"
    "A23B1D1F2H1"
    "A23B1D1F2H1I2"
    "A23B1D1F2H2"
    "A23B1D3F3H1I1"
    "A23B1D3F3H2I2"
    "A23B1D3F4H1I2"
    "A23B1D4F1G1I1K2"
    "A23B1D4F1H2J2"
    "A23B1E2G1H2"
    "A23B2C1E2G2H1J2"
    "A23B2C1E2G2I1"
    "A23B3D2F2H1"
    "A23B3D2F2H2"
    "A23B4D4F3H2J1"
    "A23B4E2G1H2"
    "A23C2E1G2I2"
    "A23C4E4G2I1"
)

# 1. Create a new timestamped directory for the verification run.
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
VERIFICATION_DIR="$SCRIPT_DIR/VerifyScienceProducts/$TIMESTAMP"

echo "Creating verification directory: $VERIFICATION_DIR"
if [ -d "$VERIFICATION_DIR" ]; then
    echo "Error: Directory '$VERIFICATION_DIR' already exists. Aborting."
    exit 1
fi
mkdir -p "$VERIFICATION_DIR"

# 2. Copy only the specified Wolfram Language source files to the new directory.
SOURCE_DIR="$SCRIPT_DIR/system-tests-paper-z"
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' not found. Aborting."
    exit 1
fi

echo "Copying required analysis scripts from '$SOURCE_DIR'..."
for model_name in "${MODELS_TO_VERIFY[@]}"; do
    source_file="ParticleSpectrograph${model_name}.m"
    full_source_path="$SOURCE_DIR/$source_file"
    if [ -f "$full_source_path" ]; then
        cp "$full_source_path" "$VERIFICATION_DIR/"
    else
        echo "Warning: Source file '$full_source_path' for model '$model_name' not found. Skipping."
    fi
done
echo "Finished copying required files."

# 3. Change to the new directory.
echo "Changing to directory '$VERIFICATION_DIR'..."
cd "$VERIFICATION_DIR"

# 4. Run the analyses for the specified models.
echo "Starting PSALTer analyses for the 22 specified models..."
for model_name in "${MODELS_TO_VERIFY[@]}"; do
    source_file="ParticleSpectrograph${model_name}.m"
    if [ -f "$source_file" ]; then
        echo "--------------------------------------------------"
        echo "Running analysis for model: $model_name"
        echo "--------------------------------------------------"
        wolfram -run < "$source_file"
        echo "--------------------------------------------------"
        echo "Finished analysis for model: $model_name"
        echo "--------------------------------------------------"
    else
        # This warning helps to identify typos in the model list or missing files.
        echo "Warning: Source file '$source_file' for model '$model_name' was not copied. Skipping run."
    fi
done

echo "All verification tasks completed successfully."
exit 0
