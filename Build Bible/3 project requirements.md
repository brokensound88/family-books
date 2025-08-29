# Project Requirements Document for FamilyBooks

## **Overview**

**FamilyBooks** is an iOS 18-first mobile application designed to empower families to manage their finances, synchronize bank accounts, superannuation (with a focus on the Australian market), savings, and investment accounts, educate children on saving and investing, and balance household budgets through a visually stunning, gamified interface. Built entirely in **Swift** and **SwiftUI**, the app leverages the latest iOS 18 capabilities to deliver a native, high-performance experience on iPhone and iPad, with potential future expansion to macOS via Mac Catalyst. Development will utilize **Windsurf** (configured as a Swift-focused IDE) and **Cursor** (an AI-driven IDE) for vibe-coding, harnessing AI tools like GitHub Copilot and Figma plugins (Magician, Builder.io) to accelerate wireframing, code generation, and prototyping. This Project Requirements Document defines the functional, non-functional, technical, and user requirements for the app’s Minimum Viable Product (MVP), scheduled for launch by July 2026 (adjusted from the original plan due to the current date of August 27, 2025). The requirements integrate modern iOS 18 frameworks (e.g., FinanceKit, CoreML, LocalAuthentication for FaceID, SwiftData, WidgetKit, StoreKit) and financial APIs (Plaid, Yodlee), ensuring compliance with PCI DSS, GDPR, and Australia’s Privacy Act, while providing a clear blueprint for vibe-coding workflows.

## **Objectives**

- Deliver an iOS 18 MVP by July 2026, featuring core functionalities: financial account syncing, budgeting, kids’ education, investment tracking, and family collaboration.
- Utilize Swift/SwiftUI and iOS 18 frameworks for a native, accessible, and engaging user experience.
- Ensure compliance with Apple’s App Store guidelines, financial regulations, and privacy laws.
- Leverage Windsurf and Cursor for AI-assisted vibe-coding to streamline development and testing.
- Support scalability for future macOS expansion and feature iterations.
- Achieve a 4.5+ App Store rating through robust functionality and user-centric design.
- Target 10,000 active users within the first year post-launch (by August 2027).

## **Scope**

### **MVP Features**

The MVP will include the following core features, tailored for iOS 18 and Australian families:

1. **Financial Account Integration**:
   - Sync bank accounts, superannuation, savings, and investments via Plaid, Yodlee, and FinanceKit (iOS 18.4+).
   - Support manual CSV imports for unsupported accounts.
2. **Budgeting and Bookkeeping**:
   - Manage zero-based budgets with customizable categories using SwiftData.
   - AI-driven transaction categorization with CoreML for offline use.
3. **Kids’ Education Module**:
   - Interactive lessons and virtual stock portfolios for kids (ages 8–18).
   - Track savings goals with parental oversight via FaceID authentication.
4. **Investment and Savings Tracking**:
   - Monitor portfolios and superannuation with dynamic SwiftUI charts.
   - Provide AI-driven savings suggestions.
5. **Family Collaboration**:
   - Multi-user accounts with role-based access (admin for parents, limited for kids).
   - Real-time updates using CloudKit or Firebase.
6. **Notifications**:
   - Push notifications for bill reminders and goal updates via WidgetKit and UserNotifications.
7. **Settings**:
   - Customize themes, manage accounts, and configure biometric authentication.

### **Future Features (Post-MVP)**

- macOS version via Mac Catalyst.
- Advanced investment analytics (e.g., robo-advisory).
- International market support with localized currencies.

## **Functional Requirements**

### **User Requirements**

- **User Registration and Authentication**:
  - Support email/password, Apple Sign-In, and FaceID (LocalAuthentication).
  - Example:

    ```swift
    // ios/FamilyWealthBuilder/Services/AuthService.swift
    import LocalAuthentication
    class AuthService {
        func authenticateWithFaceID() async -> Bool {
            let context = LAContext()
            return await withCheckedContinuation { continuation in
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock FamilyBooks") { success, _ in
                    continuation.resume(returning: success)
                }
            }
        }
    }
    ```

- **Account Syncing**:
  - Sync up to 10 accounts per user with Plaid, Yodlee, or FinanceKit.
  - Handle errors with offline caching in SwiftData.
- **Budget Management**:
  - Create/edit budgets with a maximum of 20 categories.
  - Display spending progress with animated SwiftUI progress bars.
- **Kids’ Module**:
  - Provide 5 educational lessons (e.g., “Saving Basics”) with quizzes.
  - Support virtual portfolios with real-time stock data via Plaid.
- **Investment Tracking**:
  - Display portfolio performance with SwiftUI `Chart` views.
  - Update superannuation balances daily.
- **Family Collaboration**:
  - Support 1 admin (parent) and up to 4 child accounts per family.
  - Share goals with real-time CloudKit sync.
- **Notifications**:
  - Send 5+ notifications/month (e.g., bill due, goal achieved).
  - Integrate with WidgetKit for home screen updates.

### **Admin Requirements**

- Monitor user activity and approve kids’ goals.
- Manage subscription tiers via StoreKit.

## **Non-Functional Requirements**

### **Performance**

- **Response Time**: API calls <500ms, app load <2 seconds.
- **Scalability**: Support 10,000 concurrent users with CloudKit/Firestore.
- **Uptime**: 99.9% availability for backend services.

### **Security**

- **Encryption**: End-to-end encryption for API calls (TLS 1.3) and local data (SwiftData).
- **Authentication**: Multi-factor authentication with FaceID and Apple Sign-In.
- **Compliance**: PCI DSS for payment processing, GDPR for data privacy, Australia’s Privacy Act for local regulations.
- Example:

  ```swift
  // ios/FamilyWealthBuilder/Services/EncryptionService.swift
  import CryptoKit
  class EncryptionService {
      func encrypt(data: String) -> String {
          let data = data.data(using: .utf8)!
          let sealedBox = try! ChaChaPoly.seal(data, using: .init(material: "secureKey".data(using: .utf8)!))
          return sealedBox.combined.ciphertext.base64EncodedString()
      }
  }
  ```

### **Usability**

- **Accessibility**: Full VoiceOver and Dynamic Type support.
- **Localization**: English and Australian English (Localizable.strings).
- **Device Compatibility**: iOS 18 on iPhone 14+, iPad Air 5+.

### **Maintainability**

- **Code Quality**: 90%+ test coverage, documented with SwiftDoc.
- **Update Frequency**: Bi-monthly releases via App Store Connect.

## **Technical Requirements**

### **Platform and Frameworks**

- **iOS 18**: Minimum version for FinanceKit, SwiftData, and WidgetKit.
- **Swift 5.9+**: Latest concurrency features (async/await).
- **SwiftUI**: Native UI with `Chart`, `Animation`, and accessibility.
- **Core Frameworks**:
  - **FinanceKit**: Sync Apple Wallet accounts (iOS 18.4+).
  - **SwiftData**: Local persistence for budgets and transactions.
  - **CoreML**: On-device AI for transaction categorization.
  - **LocalAuthentication**: FaceID for secure access.
  - **WidgetKit**: Home screen widgets for quick insights.
  - **StoreKit**: In-app purchases and subscriptions.
- **External APIs**:
  - Plaid/Yodlee: Financial data syncing.
  - Firebase/CloudKit: Real-time data and notifications.
  - Stripe: Payment processing.

### **Development Tools**

- **Windsurf**: Swift IDE with Copilot for vibe-coding.
- **Cursor**: AI-driven IDE for SwiftUI, testing, and deployment.
- **Xcode 16**: Primary environment for iOS 18 development.
- **Figma + Magician/Builder.io**: AI-assisted design and SwiftUI export.
- **GitHub**: Version control with branches for features.

### **Infrastructure**

- **Cloud Services**: Firebase (authentication, Firestore, Analytics), AWS SageMaker (AI), CloudKit (sync).
- **CI/CD**: Fastlane for automated builds and deployment.

## **User Personas**

1. **Parent Persona (Sarah, 35)**:
   - **Background**: Middle-income Australian mother, manages family finances.
   - **Needs**: Easy budgeting, superannuation tracking, kid education.
   - **Pain Points**: Time constraints, complex financial tools.
   - **Usage**: Daily budget checks, weekly goal reviews.
2. **Child Persona (Liam, 12)**:
   - **Background**: School student interested in games.
   - **Needs**: Fun savings goals, investment learning.
   - **Pain Points**: Boring finance apps.
   - **Usage**: Weekly savings updates, monthly lessons.

## **Constraints**

- **iOS Version**: iOS 18+ limits compatibility to ~60% of iPhone users by mid-2026.
- **API Costs**: Plaid/Yodlee ($500–$5,000/month), Firebase ($500–$2,000/month).
- **FinanceKit**: Requires iOS 18.4+, with Plaid/Yodlee as fallback.
- **Development Time**: 6–9 months from September 2025 to July 2026.

## **Assumptions**

- 60%+ of target users will adopt iOS 18 by launch.
- Plaid/Yodlee APIs will support Australian super funds.
- Apple will approve FinanceKit integration in the App Store.

## **Vibe-Coding Workflow**

### **Tools**

- **Windsurf**: Swift IDE with Copilot for code generation.
- **Cursor**: AI-driven IDE for SwiftUI, with prompts like:

  ```swift
  // Create a SwiftUI view for a budget dashboard with animated charts
  ```

- **Figma + Magician/Builder.io**: Wireframing and SwiftUI export.

### **Process**

1. **Requirements Gathering (Now–September 2025)**:
   - Use Windsurf to draft requirements, refine with Cursor prompts.
   - Example: “Generate Swift code for a FinanceKit account sync service.”
2. **Design (October–November 2025)**:
   - Create wireframes in Figma, export to SwiftUI.
3. **Development (December 2025–April 2026)**:
   - Code sprints with AI prompts (e.g., “Generate SwiftUI kids’ savings view”).
4. **Testing (May–June 2026)**:
   - Use Cursor for XCTest cases, Windsurf for SwiftData validation.
5. **Deployment (July 2026)**:
   - Automate with Fastlane, monitor with Firebase.

## **Success Criteria**

- **Functionality**: All MVP features operational by April 2026.
- **Performance**: API responses <500ms, app loads <2 seconds.
- **Security**: No critical vulnerabilities in testing.
- **Usability**: 90%+ of beta testers find app intuitive.
- **Compliance**: Meets Apple, PCI DSS, GDPR, and Privacy Act standards.

## **Conclusion**

This Project Requirements Document provides a comprehensive blueprint for **FamilyBooks**, leveraging Swift/SwiftUI and iOS 18 frameworks for a modern, family-focused finance app. By defining clear functional and non-functional requirements, the document ensures a robust MVP by July 2026. Utilizing Windsurf and Cursor for vibe-coding, the plan supports efficient development, compliance, and a high-quality user experience.

*Word Count: ~1900*

```

---
