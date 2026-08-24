# 📈 Live Stock Trading & Simulation Engine

A high-performance Flutter trading simulation application built with **Clean Architecture** and **BLoC State Management**. Features high-frequency real-time mock price feeds, dynamic benchmark index tracking, interactive order routing, native haptics, and local persistence.

---

## ✨ Key Features

- **⚡ High-Frequency Market Stream:** Real-time multi-stock price feed with configurable tick rate (1 to 50 ticks/sec).
- **📊 Benchmark Indices Bar:** Real-time dynamic NIFTY 50 and SENSEX benchmark tracking.
- **📈 Real-Time Charting:** Dynamic waveform price sparklines and volume/high/low/spread metrics.
- **📋 Watchlist Management:** Custom watchlist creation, multi-tab filtering, reordering, and swipe-to-delete.
- **💼 Interactive Order Execution:**
    - Live margin and held-quantity checks.
    - Animated auto-dismissing success dialog (1.5s).
    - One-tap quick wallet top-up modal.
- **📳 Native Haptics:** Integrated haptic feedback on tab changes, deletion impacts, and trade confirmations.
- **💾 Local Persistence:** Offline-first state persistence for wallet balance, holdings, and order audit history.
- **🌗 Theme Toggle:** Seamless dark/light theme switching.

---

## 🏛️ Architecture & Tech Stack

- **State Management:** `flutter_bloc`
- **Architecture:** Clean Architecture (Presentation, Domain, Data Layers)
- **Persistence:** `shared_preferences`, `sqflite`
- **Formatting & Helpers:** `intl`