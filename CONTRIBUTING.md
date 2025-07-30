# Contributing to Airway Ally

Thank you for your interest in contributing to Airway Ally! This document provides guidelines for contributing to the project.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.32.6 or higher
- Dart SDK 3.0 or higher
- Git
- A GitHub account

### Development Setup

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/airway_ally.git
   cd airway_ally
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Create a Firebase project
   - Add configuration files
   - Update API keys

4. **Run the app**
   ```bash
   flutter run
   ```

## 📋 Development Guidelines

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### File Structure
```
lib/
├── core/           # Global utilities, themes, constants
├── features/       # Feature modules
├── providers/      # Riverpod providers
├── services/       # API and business logic
└── utils/          # Helper functions
```

### Testing
- Write unit tests for business logic
- Write widget tests for UI components
- Maintain test coverage above 80%
- Run tests before submitting PRs

### Commit Messages
Use conventional commit format:
```
type(scope): description

feat(auth): add biometric authentication
fix(chat): resolve message sync issue
docs(readme): update installation instructions
```

## 🔄 Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, documented code
   - Add tests for new functionality
   - Update documentation if needed

3. **Test your changes**
   ```bash
   flutter analyze
   flutter test
   flutter build apk --release
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat(scope): description of changes"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Use the PR template
   - Describe your changes clearly
   - Link any related issues

## 🧪 Testing Guidelines

### Unit Tests
- Test business logic in services
- Test provider state management
- Mock external dependencies

### Widget Tests
- Test UI components
- Test user interactions
- Test error states

### Integration Tests
- Test complete user flows
- Test real-time features
- Test cross-platform functionality

## 📝 Documentation

### Code Documentation
- Document public APIs
- Add inline comments for complex logic
- Update README for new features

### User Documentation
- Update feature documentation
- Add screenshots for UI changes
- Update installation instructions

## 🐛 Bug Reports

When reporting bugs, please include:
- **Description**: Clear description of the issue
- **Steps to reproduce**: Detailed steps
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: OS, Flutter version, device
- **Screenshots**: If applicable

## 💡 Feature Requests

When requesting features, please include:
- **Description**: Clear description of the feature
- **Use case**: Why this feature is needed
- **Proposed implementation**: How it could work
- **Mockups**: If applicable

## 🔒 Security

- Don't commit sensitive data (API keys, passwords)
- Use environment variables for secrets
- Report security issues privately
- Follow security best practices

## 📊 Performance

- Optimize for performance
- Minimize memory usage
- Use efficient data structures
- Profile code when needed

## 🌐 Accessibility

- Follow accessibility guidelines
- Use semantic widgets
- Provide alternative text
- Test with screen readers

## 🤝 Community Guidelines

- Be respectful and inclusive
- Help other contributors
- Provide constructive feedback
- Follow the code of conduct

## 📞 Getting Help

- **Issues**: Use GitHub Issues
- **Discussions**: Use GitHub Discussions
- **Documentation**: Check the wiki
- **Chat**: Join our community chat

## 🏆 Recognition

Contributors will be recognized in:
- README contributors section
- Release notes
- Project documentation

Thank you for contributing to Airway Ally! 🚀 