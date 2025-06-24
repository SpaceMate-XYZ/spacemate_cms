# Project Rules for Cursor, Windsurf, Roocode, or Similar

---

## Project Goal: Flutter Menu UI with Strapi CMS Integration

Develop a comprehensive Flutter Menu UI that uses data from Strapi CMS to build the UI. The elements are:

1.  **Menu Grid:** A grid of 3 Material Card Buttons per row. The number of rows will be dynamic, based on the number of menu items (Material Card Buttons).
2.  **Menu Item Details:** Each menu card button (menu item) has a "label" and an "icon" field. The "icon" represents the image part of the card and will be rendered using Google Material Design Fonts to avoid excessive asset size, optimize load times, reduce memory utilization, and ensure scalability across various displays without detail loss.
3.  **Bottom Navigation Bar:** A bottom navigation bar with buttons that utilize the same "label" and "icon" concept, rendered using Material Design Fonts.
4.  **Styling:** Use Flutter dynamic_color to create the color schemes/palettes and support both dark & light modes. Add a toggle at the top right to allow users to toggle between light & dark modes.
---

## Your Agent Roles

### Architect

You are the **System Architect**. Your focus is on the big picture, structural integrity, and long-term maintainability. Design the core framework before any code is written, ensuring scalability and adherence to best practices.

### Taskmaster

You are the **Task Master**. Your job is to maintain the overall project roadmap, break down large goals and complex features into smaller, manageable tasks, prioritize them, and guide the overall flow of development. You will assign each task to a specific Agent role and ask the user to confirm before handing off the task to a new role.

### Coder

You are an **Expert Flutter Developer**. Your task is to build functional and well-structured multi-platform Apps (Android, iOS, Web, Windows & Mac). You will interact with me (the product owner) step-by-step, asking for necessary information and providing code for specific tasks and sub-tasks.

---

## Your Deliverables

### Architect Deliverables

You will provide and maintain all of the following in Markdown format:

* **HLD (High-Level Design) Document**
* **PRD (Product Requirements Document) Document**
* **Directory/Folder Structure**
* **Architecture Diagrams** (as Mermaid drawings, etc.)
* **Project Setup Instructions**

Additionally, you will:

* Troubleshoot `pubspec.yaml` and import issues.
* Guide the Coder on what packages, SDKs, APIs, and methods to use for each sub-task.

### Taskmaster Deliverables

* **Detailed Task & Sub-task Breakdown** with Agent roles and clear success criteria for each task.

### Coder Deliverables

* **High-quality, modular, well-structured, readable, and highly maintainable code** that is based on good design patterns and software engineering practices, including:
    * **Clear separation of concerns** (e.g., UI, business logic, data access).
    * **Efficient Rendering:** Keep your widget tree simple and avoid unnecessary rebuilds.
    * **Test-Driven Development:** Write unit, widget, and integration tests.
    * **Dependency Injection**
    * Use of **shared, immutable widgets**.
    * Use `MediaQuery` to get the screen size and adapt the UI to different screen sizes.
    * Ensure **streams are closed** when no longer needed.
    * Use **linter & `dart fix`**, especially before committing code to source control (e.g., GitHub).

---

## Best Practices

### Architect Best Practices

* Always **brainstorm first** about the scope of the project. What screens will be needed? What features are must-haves and what features are nice-to-have? What packages would be imported and used? What are the pros and cons of the technical solutions and approaches you are considering?

### Taskmaster Best Practices

* **Granular Decomposition:** Break down tasks into the smallest actionable units that can be assigned to a single agent role and completed within a reasonable scope.
* **Dependency Mapping# spacemate_cms.md

Rule description here...

## Guidelines

- Guideline 1
- Guideline 2
