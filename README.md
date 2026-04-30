# Intelligent Admissions Assistant (IAA) - v2

An AI-driven automation ecosystem designed to streamline the university admission process for **UAF Burewala Campus**. This project integrates mobile technology, low-code automation, and Artificial Intelligence to transform a manual workflow into a digital-first experience.

---

## ⚠️ Proprietary Notice & License
**Copyright (c) 2026 Muhammad Awais Rafique. All rights reserved.**

This software and its associated documentation are the exclusive intellectual property of the author. 
- **Institutional Use:** Unauthorized use by any educational institution for administrative purposes is strictly prohibited without a formal licensing agreement.
- **Academic Use:** This repository is public for portfolio showcase and academic evaluation only.
- **Commercial Use:** Requires explicit written consent.

---

## 🚀 Overview
The **Intelligent Admissions Assistant** solves the common "bottleneck" during admission cycles: manual data entry, slow merit list generation, and repetitive student inquiries. 

### Key Problems Solved:
* **Manual Verification:** Automates the cross-checking of student documents.
* **Inquiry Overload:** Uses an AI-integrated backend to handle common admission FAQs.
* **Data Inconsistency:** Ensures student records are synced across mobile and administrative databases.

---

## 🛠 Tech Stack
This project utilizes a modern **Multi-Agent Architecture**:

*   **Frontend:** [Flutter](https://flutter.dev/) (Cross-platform Mobile UI)
*   **Orchestration:** [n8n](https://n8n.io/) (Workflow Automation & Logic Engine)
*   **Intelligence:** Integrated AI Models (LLMs) for document parsing and assistant logic.
*   **Database:** Firebase / PostgreSQL (Real-time data synchronization)

---

## 🏗 System Architecture
The system follows a decoupled architecture where the mobile app acts as a thin client, and the "intelligence" resides in a secure automation layer:

1. **User Tier:** Flutter app collects student data and documents.
2. **Logic Tier:** n8n processes incoming webhooks, validates data, and triggers AI analysis.
3. **Intelligence Tier:** AI models evaluate documents and provide instant feedback via the assistant.
4. **Data Tier:** Centralized storage for administrative merit list generation.

---

## ✨ Features (v2)
- ✅ **Smart Application Submission:** Interactive UI for error-free form filling.
- ✅ **AI Assistant:** Real-time help for admission-related queries.
- ✅ **Automated Notifications:** Instant updates on merit list standing.
- ✅ **Document Scanner:** Integrated camera functionality for document uploading.

---

## 📦 Installation & Setup
*Note: This repository does not contain private API keys or n8n workflow credentials.*

1. **Prerequisites:**
   - Flutter SDK (latest version)
   - n8n instance (Self-hosted or Cloud)

2. **Setup:**
   ```bash
   git clone [https://github.com/awaissukhera545/intelligent_admissions_v2.git](https://github.com/awaissukhera545/intelligent_admissions_v2.git)
   cd intelligent_admissions_v2
   flutter pub get
   flutter run
