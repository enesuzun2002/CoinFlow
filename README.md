# CoinFlow 🪙

A modern, high-performance cryptocurrency market tracker built natively with **SwiftUI** and modern iOS architecture standards (iOS 17+). 

Designed and engineered with zero third-party UI dependencies, leveraging Apple’s first-party frameworks for concurrency, data persistence, and data visualization.

---

## 🎯 Purpose & Engineering Motivation

With over 3 years of production experience in declarative cross-platform mobile development (Flutter), **CoinFlow** was built to transition and deepen my engineering reflexes into the native Apple ecosystem. 

The primary goals of this project:
- **Master Native State & Memory Lifecycle:** Moving beyond garbage-collected environments into Swift's deterministic ARC (Automatic Reference Counting), value semantics (`struct`), and strict thread safety.
- **Modern Concurrency & Architecture:** Implementing iOS 17+ native state management (`@Observable`) and structured concurrency (`async/await`, `Task`, `@MainActor`, `Actors`) without legacy UIKit/Combine overhead.
- **Pure Apple Frameworks:** Adhering strictly to Apple Human Interface Guidelines (HIG) and relying 100% on native APIs (`SwiftData`, `Swift Charts`, `URLSession`).

---

## 🏗 Architecture & Design Patterns

The project is structured using a **Feature-based MVVM (Model-View-ViewModel)** architectural pattern combined with **Protocol-Oriented Programming (POP)**.
