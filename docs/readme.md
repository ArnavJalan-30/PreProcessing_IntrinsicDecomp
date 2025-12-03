# 🖼️ Improving Intrinsic Image Decomposition through Pre-Processing
### Exploring how luminance & detail-based enhancement influence state-of-the-art ordinal-shading intrinsic decomposition

This repository contains the complete implementation, preprocessing pipelines, evaluation code, and experimental framework used for the thesis:

**“Improving Intrinsic Image Decomposition through Pre-Processing” — Arnav Jalan (2025)**  
Shiv Nadar Institution of Eminence, Delhi-NCR

The project systematically studies **how different pre-processing techniques affect intrinsic image decomposition**, specifically in the context of the **Ordinal Shading–based multi-stage pipeline** by *Careaga & Aksoy (SIGGRAPH 2023)*.

---

## 🚀 Project Overview

Intrinsic image decomposition splits an input RGB image **I** into:

- **Albedo / Reflectance (A)** – material color  
- **Shading (S)** – illumination, geometry, shadows  

Equation:  
`I ≈ A × S`

This repository implements:

1. A reproducible version of the **Ordinal Shading** pipeline  
2. Five separate **pre-processing techniques**  
3. Evaluation on **ARAP, IIW, and Sintel** datasets  
4. Metrics: **LMSE, RMSE, SSIM, WHDR**  
5. Qualitative visual comparisons and residual analysis  

---

## 📦 Repository Structure

```
PreProcessing_IntrinsicDecomp/
│── notebooks/
│── preprocessing/
│── intrinsic_pipeline/
│── datasets/
│── metrics/
│── outputs/
│── README.md
```

---

## 🔍 Pre-Processing Techniques Implemented

### **1. Histogram Equalization (HE)**
Global luminance redistribution to enhance contrast.

### **2. CLAHE (Zuiderveld, 1994)**
Tile-based localized contrast enhancement with clipping to prevent noise amplification.

### **3. Chromaticity Enhancement (MATLAB)**
Nonlinear luminance-chrominance boosting via α–γ correction.

### **4. Detail Enhancement via Generalized Smoothing (Liu et al., TPAMI 2021)**
Edge-preserving smoothing + detail amplification:

```
I_detail = I + k * (I - B)
```

### **5. LCDPNet (ECCV 2022)**
Deep learning–based exposure correction using Local Color Distributions.

---

## 🧠 Core Intrinsic Decomposition Pipeline (Ordinal Shading)

Based on **Careaga & Aksoy (SIGGRAPH 2023)**.  
Pipeline includes:

### **Stage 1 — Ordinal Shading Prediction**
Low-res & high-res inverse shading ordering.

### **Stage 2 — Grayscale Shading Reconstruction**
Converts ordinal ordering → metric shading.

### **Stage 3 — Chromatic Shading (IUV space)**
Handles colored illumination and tinted shadows.

### **Stage 4 — High-Resolution Albedo Refinement**
Restores textures, material edges, and fine detail.

### **Stage 5 — Diffuse Shading + Residual**
`Residual = I - (A × S)`  
Captures specular highlights and unmodeled lighting.

---

## 📊 Datasets Used

### **ARAP Dataset**
Physically rendered indoor scenes with dense albedo & shading GT.

### **Intrinsic Images in the Wild (IIW)**  
Real photos + human pairwise reflectance judgments.  
Evaluated using **WHDR**.

### **MPI Sintel (Intrinsic)**  
Physically-based synthetic scenes; only Frame-1 per category used.

---

## ⚙️ Installation

### Clone the repository
```
git clone https://github.com/ArnavJalan-30/PreProcessing_IntrinsicDecomp
cd PreProcessing_IntrinsicDecomp
```

### Install dependencies
```
pip install -r requirements.txt
```

---

## ▶️ Running the Pipeline

### Baseline:
```
python run_pipeline.py --input data/original/ --output outputs/baseline/
```

### Histogram Equalization:
```
python run_pipeline.py --preprocess he
```

### CLAHE:
```
python run_pipeline.py --preprocess clahe
```

### Detail Enhancement:
```
python run_pipeline.py --preprocess detail --k 5
```

### Chromaticity Enhancement:
Run the MATLAB scripts in:
```
preprocessing/chromaticity_enhancement/
```

### LCDPNet:
Follow instructions in:
```
preprocessing/LCDPNet/
```

---

## 📈 Evaluation Metrics

- **LMSE**
- **RMSE**
- **SSIM** (Wang et al., 2004)
- **WHDR** (Bell et al., 2014)

```
python evaluate.py --pred outputs/he/ --gt data/gt/
```

---

## 🖼️ Sample Outputs (Add your images)

| Input | Albedo | Shading | Residual |
|------|--------|---------|----------|
| ![](examples/in.png) | ![](examples/albedo.png) | ![](examples/shading.png) | ![](examples/residual.png) |

---

# 🙏 Credits & Acknowledgements

This project builds upon publicly available work:

### **Intrinsic Decomposition**
- Careaga & Aksoy (2023), *Ordinal Shading*  
  https://github.com/YağızAksoy/ordinal_shading

### **Detail Enhancement**
- Liu et al. (2021), *Generalized Edge/Structure-Preserving Smoothing*

### **LCDPNet**
- Wang et al. (ECCV 2022), *Local Color Distributions Prior*

### **CLAHE**
- Zuiderveld (1994), *Graphics Gems IV*

### **Datasets**
- Butler et al. (2012) — MPI Sintel  
- Bell et al. (2014) — IIW  

### **SSIM**
- Wang et al. (2004)

Thanks to all original authors for open-sourcing their work.  
This repository is for **academic and research purposes only**.

---

## 📄 License
This project uses the **MIT License**, but individual folders retain the licenses of their original authors.

---

## ✉️ Contact
For questions & collaborations:  
**arnavjalan9@gmail.com**


