# AGENTS.md - Portal Akademik Development Agents

**AI-Powered Development Strategy**  
**Last Updated:** 2024-11-11  
**Version:** 1.0.0

---

## 📋 Table of Contents
1. [Overview](#-overview)
2. [Agent Architecture](#-agent-architecture)
3. [Specialized Agents](#-specialized-agents)
4. [Agent Prompts Library](#-agent-prompts-library)
5. [Development Workflow](#-development-workflow)
6. [Best Practices](#-best-practices)

---

## 🤖 Overview

Dokumen ini berisi strategi penggunaan AI Agents (seperti Claude, ChatGPT, Cursor AI, GitHub Copilot) untuk mempercepat development Portal Akademik. Setiap agent memiliki specialization dan prompt template yang sudah dioptimasi.

### Why Use AI Agents?

✅ **Productivity Boost:** 3-5x faster development  
✅ **Code Quality Metrics:
- Test coverage: 85% (target: 80%)
- Zero critical bugs in first month
- Code review approval rate: 95%
- Performance: All APIs < 500ms response time

Key Success Factors:
✅ Clear, detailed prompts
✅ Iterative refinement
✅ Thorough manual review
✅ Comprehensive testing
✅ Proper agent specialization
```

#### Case 2: Testing Suite Generation
```markdown
Task: Generate comprehensive test suite
Manual effort: ~1 week
With Testing Agent: ~1.5 days
Speedup: 3.5x

Generated:
- 150+ unit tests
- 50+ integration tests
- 20+ E2E test scenarios
- Test coverage: 88%

Developer feedback:
"AI generated test cases I didn't think of"
"Saved massive amount of time"
"Tests are well-structured and maintainable"
```

#### Case 3: Documentation Sprint
```markdown
Task: Complete API documentation
Manual effort: ~3 days
With Documentation Agent: ~6 hours
Speedup: 4x

Generated:
- OpenAPI/Swagger docs for 50+ endpoints
- Code comments for all services
- User guides for 3 user roles
- Deployment documentation

Quality:
- Consistent formatting
- Clear examples
- Comprehensive coverage
- Easy to maintain
```

---

## 🎯 Implementation Roadmap

### Week 1: Setup & Training
- [ ] Choose AI tools (Claude, Copilot, Cursor)
- [ ] Setup IDE integrations
- [ ] Create prompt templates
- [ ] Train team on prompt engineering
- [ ] Setup agent workflow
- [ ] Create agent log system

### Week 2-4: Backend with Agents
- [ ] Use Database Agent for schema design
- [ ] Use Backend Agent for API development
- [ ] Use Testing Agent for test generation
- [ ] Use Security Agent for code review
- [ ] Track productivity metrics

### Week 5-8: Frontend with Agents
- [ ] Use Frontend Agent for components
- [ ] Use Testing Agent for component tests
- [ ] Use Documentation Agent for component docs
- [ ] Track code quality metrics

### Week 9-10: Integration & Testing
- [ ] Use Testing Agent for E2E tests
- [ ] Use Security Agent for full security audit
- [ ] Use DevOps Agent for deployment setup

### Week 11-12: Documentation & Polish
- [ ] Use Documentation Agent for all docs
- [ ] Final code review with agents
- [ ] Performance optimization with agents
- [ ] Prepare for deployment

---

## 🔧 Troubleshooting

### Common Issues & Solutions

#### Issue 1: Generated Code Doesn't Compile
**Problem:** AI generated code with syntax errors

**Solutions:**
```markdown
1. Break down prompt into smaller pieces
2. Provide more context about existing code
3. Ask agent to review and fix its own code
4. Use a more capable model (e.g., GPT-4 vs GPT-3.5)

PROMPT:
"The code you generated has compilation errors.
Please review and fix these errors:
[paste error messages]

Code:
[paste code]"
```

#### Issue 2: Code Doesn't Follow Project Patterns
**Problem:** Generated code uses different style/structure

**Solutions:**
```markdown
1. Provide examples of existing code
2. Be explicit about coding standards
3. Use few-shot learning technique

PROMPT:
"Here's how we structure services in this project:
[paste example]

Please generate [X] following the EXACT same pattern."
```

#### Issue 3: Generated Tests Don't Cover Edge Cases
**Problem:** Tests only cover happy path

**Solutions:**
```markdown
PROMPT:
"The tests you generated don't cover these edge cases:
1. [edge case 1]
2. [edge case 2]
3. [edge case 3]

Please add tests for:
- Null/undefined inputs
- Empty arrays/strings
- Boundary values
- Error conditions
- Race conditions
- Invalid data types"
```

#### Issue 4: Code is Over-Engineered
**Problem:** Generated code is too complex

**Solutions:**
```markdown
PROMPT:
"The code you generated is too complex.
Please simplify it following these principles:
- YAGNI (You Aren't Gonna Need It)
- KISS (Keep It Simple, Stupid)
- Single Responsibility Principle
- Maximum [X] lines per function
- No premature optimization

Refactor to be simpler and more maintainable."
```

#### Issue 5: Outdated Dependencies/Syntax
**Problem:** AI uses old library versions or deprecated syntax

**Solutions:**
```markdown
PROMPT:
"Please use the latest versions:
- React 18 (not 17)
- Prisma 5 (not 4)
- TypeScript 5 (not 4)

And use current best practices:
- React Hooks (not class components)
- Async/await (not callbacks)
- ES6+ syntax"
```

---

## 📚 Learning Resources

### Prompt Engineering Courses
- [Anthropic Prompt Engineering Guide](https://docs.anthropic.com/claude/docs)
- [OpenAI Prompt Engineering](https://platform.openai.com/docs/guides/prompt-engineering)
- [Learn Prompting](https://learnprompting.org/)
- [Prompt Engineering Guide by DAIR.AI](https://www.promptingguide.ai/)

### AI Coding Tools Tutorials
- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Cursor AI Documentation](https://cursor.sh/docs)
- [Claude API Documentation](https://docs.anthropic.com/)

### Best Practices
- [AI-Assisted Development Best Practices](https://github.blog/ai-and-ml/)
- [Clean Code with AI](https://www.freecodecamp.org/)
- [Testing with AI](https://testingjavascript.com/)

---

## 🤝 Team Collaboration

### Sharing Agent Work

**Process:**
```markdown
1. Create feature branch
2. Generate code with agents
3. Review and refine
4. Add to PR description:
   - Agent used
   - Prompt summary
   - Manual changes made
   - Testing performed
5. Request peer review
6. Merge after approval
```

**PR Template with Agent Info:**
```markdown
## Description
[Description of changes]

## AI Agent Used
- **Agent:** Backend Development Agent
- **Task:** Generate KRS validation service
- **Prompt:** [Link to prompt or summary]

## Generated Code
- `src/services/krsValidation.service.ts`
- `tests/unit/krsValidation.test.ts`

## Manual Changes
- Added custom validation for [X]
- Optimized query performance
- Fixed edge case for [Y]

## Testing
- [x] Unit tests (85% coverage)
- [x] Integration tests
- [x] Manual testing
- [x] Security review

## Checklist
- [x] Code reviewed by AI
- [x] Code reviewed by human
- [x] Tests passing
- [x] Documentation updated
- [x] No security issues
```

---

## 📋 Agent Prompts Cheat Sheet

### Quick Reference

#### Generate Backend Service
```
Generate [ServiceName] service with:
- Input: [types]
- Output: [types]
- Business logic: [describe]
- Error handling
- Validation
- Tests
- JSDoc

Tech: Node.js, TypeScript, Prisma
```

#### Generate React Component
```
Generate [ComponentName] component with:
- Props: [list]
- Features: [list]
- State: [describe]
- API calls: [endpoints]
- Validation: React Hook Form + Zod
- UI: shadcn/ui + Tailwind
- Tests: Vitest
```

#### Generate API Endpoint
```
Generate API endpoint:
- Method: [GET/POST/PUT/DELETE]
- Path: [/api/v1/...]
- Auth: [Required/Optional]
- Input: [schema]
- Output: [schema]
- Validation
- Error handling
- Tests
- Swagger docs
```

#### Generate Test Suite
```
Generate tests for:
[paste code or function name]

Include:
- Happy path
- Edge cases
- Error scenarios
- Mocking strategy
- 80%+ coverage

Framework: [Jest/Vitest]
```

#### Generate Database Schema
```
Generate Prisma schema for:
- Entity: [name]
- Fields: [list with types]
- Relations: [describe]
- Constraints: [list]
- Indexes: [list]

Include migration SQL
```

#### Debug Issue
```
Debug this issue:

Problem: [describe]
Error: [paste error]
Code: [paste code]
Context: [environment, recent changes]

Provide:
1. Root cause
2. Fix
3. Prevention
```

#### Code Review
```
Review this code for:
- Best practices
- Performance
- Security
- Maintainability
- Test coverage

Code:
[paste code]

Suggest improvements with examples
```

#### Optimize Performance
```
Optimize this code:
[paste code]

Focus on:
- Database queries
- Algorithm efficiency
- Memory usage
- Bundle size

Show before/after comparison
```

---

## 🎓 Training Program

### For New Team Members

#### Week 1: Introduction to AI Agents
**Day 1-2: Basics**
- What are AI agents?
- Available tools (Claude, Copilot, Cursor)
- Setup and installation
- Basic prompting

**Day 3-4: Prompt Engineering**
- How to write effective prompts
- Common patterns
- Iterative refinement
- Examples and practice

**Day 5: Project-Specific**
- Our agent workflow
- Prompt templates
- Quality standards
- Review process

#### Week 2: Hands-On Practice
**Day 1: Backend Development**
- Generate simple service
- Add tests
- Review and refine
- Submit PR

**Day 2: Frontend Development**
- Generate simple component
- Add tests
- Style with Tailwind
- Submit PR

**Day 3: Testing**
- Generate test suite
- Run tests
- Fix failures
- Achieve coverage target

**Day 4: Documentation**
- Generate API docs
- Write code comments
- Create user guide
- Review documentation

**Day 5: Integration**
- Work on small feature end-to-end
- Use multiple agents
- Complete workflow
- Retrospective

---

## 🔮 Future Enhancements

### Upcoming Agent Capabilities

#### 1. Autonomous Agents (2024-2025)
```markdown
Agents that can:
- Execute code and tests
- Access databases
- Make git commits
- Create PRs automatically
- Fix bugs autonomously
```

#### 2. Multi-Agent Collaboration
```markdown
Agents working together:
- Backend + Frontend agents coordinate
- Testing agent auto-runs after code generation
- Documentation agent auto-updates docs
- Security agent auto-reviews all code
```

#### 3. Project-Specific Training
```markdown
Custom agents trained on:
- Your codebase
- Your coding standards
- Your business logic
- Your common patterns
```

#### 4. Real-Time Code Review
```markdown
As you type:
- Suggest improvements
- Catch errors early
- Optimize performance
- Ensure security
```

#### 5. Predictive Development
```markdown
Agents that predict:
- What code you'll need next
- Potential bugs before they happen
- Performance bottlenecks
- Security vulnerabilities
```

---

## ✅ Success Checklist

### Before Starting with Agents

- [ ] Team trained on prompt engineering
- [ ] AI tools installed and configured
- [ ] Prompt templates created
- [ ] Quality standards documented
- [ ] Review process established
- [ ] Metrics tracking setup

### During Development

- [ ] Use appropriate agent for each task
- [ ] Write clear, detailed prompts
- [ ] Review all generated code
- [ ] Test thoroughly
- [ ] Document agent usage
- [ ] Track productivity metrics

### After Completion

- [ ] All code reviewed by humans
- [ ] All tests passing
- [ ] Documentation complete
- [ ] Security audit passed
- [ ] Performance acceptable
- [ ] Agent log updated

---

## 🆘 Getting Help

### When Agents Don't Work

1. **Refine Your Prompt**
   - Add more context
   - Be more specific
   - Provide examples
   - Break into smaller tasks

2. **Try Different Agent**
   - Claude for complex reasoning
   - GPT-4 for creative solutions
   - Copilot for quick completions

3. **Iterate**
   - Generate → Review → Refine → Repeat
   - Don't expect perfection first try

4. **Ask for Help**
   - Consult team members
   - Share prompts and results
   - Learn from each other

5. **Fall Back to Manual**
   - Sometimes manual is faster
   - Use judgment
   - Don't force AI where it doesn't fit

---

## 📖 Appendix

### A. Sample Prompts Collection

See separate file: `prompts/PROMPTS_LIBRARY.md`

### B. Agent Configuration Files

See separate file: `config/AGENT_CONFIGS.md`

### C. Team Guidelines

See separate file: `docs/AGENT_GUIDELINES.md`

### D. Metrics Dashboard

See separate file: `metrics/AGENT_METRICS.md`

---

## 📝 Version History

- **v1.0.0** (2024-11-11) - Initial AGENTS.md created
  - Complete agent architecture
  - 8 specialized agents defined
  - Comprehensive prompt library
  - Best practices and workflows
  - Training program
  - Troubleshooting guide

---

## 🙏 Acknowledgments

This guide is inspired by:
- Anthropic's Claude documentation
- OpenAI's GPT best practices
- GitHub Copilot usage patterns
- Community experiences with AI-assisted development

---

## 📞 Contact & Support

**Questions about AI agents?**
- Create issue in GitHub
- Ask in team Slack channel
- Consult with Tech Lead
- Review documentation

**Report AI-generated bugs:**
- Label as `ai-generated`
- Include original prompt
- Document agent used
- Describe issue clearly

---

**Remember:** AI agents are powerful tools to augment your capabilities, not replace your judgment. Use them wisely, review thoroughly, and always prioritize code quality and security! 🚀

---

*Last Updated: 2024-11-11*  
*Next Review: Monthly or as needed*  
*Maintained by: Development Team*

---

## 🎯 Quick Start Guide

**Never used AI agents before? Start here:**

### 1. Install Tools (5 minutes)
```bash
# Install GitHub Copilot in VS Code
# Or install Cursor AI
# Or use Claude via web
```

### 2. Try First Prompt (10 minutes)
```markdown
Generate a simple React button component with:
- TypeScript
- Click handler
- Loading state
- Disabled state
- Tailwind styling

Show me the code.
```

### 3. Review & Learn (5 minutes)
- Did it generate correct code?
- What did you like?
- What would you change?
- How can you improve the prompt?

### 4. Iterate (10 minutes)
```markdown
The button looks good, but please:
- Add hover effect
- Add icon support
- Make size configurable
- Add unit tests
```

### 5. Practice Daily
- Use agents for small tasks first
- Build up complexity gradually
- Share learnings with team
- Track your productivity improvements

**Goal:** Generate your first production-ready code with AI by end of Week 1! 🎉

---

*Happy coding with AI agents! 🤖✨*:** Consistent patterns & best practices  
✅ **Learning Curve:** Faster onboarding for new tech  
✅ **Documentation:** Auto-generate docs & tests  
✅ **Bug Detection:** Early error detection  
✅ **Refactoring:** Easier code improvements  

### Agent Types

1. **Code Generation Agents** - Generate boilerplate, APIs, components
2. **Code Review Agents** - Review code quality, security, performance
3. **Testing Agents** - Generate test cases and test code
4. **Documentation Agents** - Write docs, comments, guides
5. **Debugging Agents** - Find bugs, suggest fixes
6. **Architecture Agents** - Design system architecture, patterns

---

## 🏗️ Agent Architecture

### Multi-Agent Development System

```
┌─────────────────────────────────────────────────────────────┐
│                    Project Manager Agent                     │
│         (Oversees project, coordinates other agents)         │
└───────────────────────┬─────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
┌───────▼────────┐ ┌───▼────────┐ ┌───▼────────┐
│  Backend Agent │ │Frontend    │ │  DevOps    │
│                │ │Agent       │ │  Agent     │
│ • API Dev      │ │• UI/UX     │ │• CI/CD     │
│ • Database     │ │• Components│ │• Deploy    │
│ • Services     │ │• State Mgmt│ │• Monitor   │
└────────┬───────┘ └────┬───────┘ └────┬───────┘
         │              │              │
    ┌────▼──────────────▼──────────────▼────┐
    │                                        │
┌───▼────────┐ ┌──────────┐ ┌──────────────▼──┐
│   Testing  │ │  Docs    │ │    Security      │
│   Agent    │ │  Agent   │ │    Agent         │
│            │ │          │ │                  │
│ • Unit     │ │• API Docs│ │• Vulnerability   │
│ • E2E      │ │• Guides  │ │• Code Review     │
│ • Security │ │• Comments│ │• Best Practices  │
└────────────┘ └──────────┘ └──────────────────┘
```

---

## 🎯 Specialized Agents

### 1️⃣ Project Manager Agent

**Role:** Oversee entire project, coordinate tasks, ensure consistency

**Capabilities:**
- Break down requirements into tasks
- Create project timeline
- Coordinate between agents
- Review overall progress
- Ensure best practices

**Prompt Template:**
```markdown
You are a Senior Technical Project Manager for the Portal Akademik project.

CONTEXT:
- Tech Stack: React 18, Node.js 20, PostgreSQL 15, Prisma, TypeScript
- Team Size: [X] developers
- Timeline: 6 months
- Current Phase: [Phase name]

TASK:
[Specific task description]

CONSTRAINTS:
- Follow SOLID principles
- Use TypeScript strictly
- Write tests for all features
- Document all APIs
- Follow security best practices

DELIVERABLES:
1. [Specific deliverable 1]
2. [Specific deliverable 2]
...

Please provide:
1. Step-by-step implementation plan
2. Code structure recommendations
3. Potential risks and mitigations
4. Testing strategy
5. Timeline estimate
```

**Example Usage:**
```markdown
TASK: Plan the KRS module implementation

[Agent will provide detailed breakdown of:
- Database schema needed
- API endpoints required
- Frontend components
- Validation logic
- Testing requirements
- Timeline estimate]
```

---

### 2️⃣ Backend Development Agent

**Role:** Generate backend code, APIs, database schemas, business logic

**Capabilities:**
- Generate Prisma schemas
- Create Express routes & controllers
- Write business logic & services
- Implement validation
- Generate API documentation

**Prompt Template:**
```markdown
You are an Expert Backend Developer specializing in Node.js, TypeScript, Express, and Prisma.

PROJECT CONTEXT:
- Framework: Express.js with TypeScript
- ORM: Prisma with PostgreSQL
- Architecture: Clean Architecture (Controllers → Services → Repositories)
- Auth: JWT with refresh tokens

TASK: [Specific backend task]

REQUIREMENTS:
- Use TypeScript strictly with proper types
- Follow RESTful API conventions
- Implement proper error handling
- Add input validation (Joi/Zod)
- Include JSDoc comments
- Write unit tests
- Generate Swagger documentation

CONSTRAINTS:
- Response format must match project standard
- All database queries must use Prisma
- Implement proper transaction handling
- Follow security best practices (OWASP)

Please provide:
1. Complete implementation code
2. Type definitions
3. Unit test examples
4. API documentation (OpenAPI format)
5. Usage examples
```

**Example: Generate KRS Validation Service**

**Prompt:**
```markdown
TASK: Create KRS validation service

REQUIREMENTS:
1. Validate prasyarat mata kuliah
2. Check jadwal bentrok
3. Validate kuota kelas
4. Check max SKS (based on IPK)
5. Verify pembayaran status
6. Check periode KRS aktif

INPUT:
- mahasiswaId: number
- kelasIds: number[]
- periodeId: number

OUTPUT:
{
  isValid: boolean,
  validations: {
    prasyarat: { passed: boolean, errors: [] },
    jadwalBentrok: { passed: boolean, conflicts: [] },
    kuota: { passed: boolean, fullClasses: [] },
    maxSks: { passed: boolean, message: string },
    pembayaran: { passed: boolean, message: string },
    periodeAktif: { passed: boolean, message: string }
  }
}

Generate complete service with:
- Full TypeScript implementation
- Helper functions
- Error handling
- Unit tests (Jest)
- JSDoc documentation
```

---

### 3️⃣ Frontend Development Agent

**Role:** Generate React components, pages, UI logic, state management

**Capabilities:**
- Create React components
- Implement forms with validation
- Generate UI layouts
- Setup state management
- Implement API integration

**Prompt Template:**
```markdown
You are an Expert Frontend Developer specializing in React 18, TypeScript, TailwindCSS, and shadcn/ui.

PROJECT CONTEXT:
- Framework: React 18 with TypeScript
- Styling: TailwindCSS + shadcn/ui
- State: Zustand + TanStack Query
- Forms: React Hook Form + Zod
- Router: React Router v6

TASK: [Specific frontend task]

REQUIREMENTS:
- Use TypeScript strictly
- Follow React best practices (hooks, composition)
- Use shadcn/ui components
- Implement proper loading & error states
- Add accessibility (ARIA labels)
- Mobile responsive
- Include unit tests (Vitest)

DESIGN REQUIREMENTS:
- Modern, clean UI
- Consistent with design system
- Intuitive UX
- Fast performance

Please provide:
1. Complete component code
2. Type definitions
3. Usage example
4. Test cases
5. Accessibility considerations
```

**Example: Generate KRS Form Component**

**Prompt:**
```markdown
TASK: Create KRS selection form component

FEATURES:
1. Display available mata kuliah as cards
2. Show multiple kelas per mata kuliah
3. Allow selection with checkboxes
4. Show summary (total MK, total SKS)
5. Real-time validation
6. Submit button with loading state

COMPONENTS TO USE:
- Card from shadcn/ui
- Button from shadcn/ui
- Badge for SKS count
- Alert for validation errors
- useQuery from TanStack Query
- useMutation for submit

STATE MANAGEMENT:
- selectedKelasIds: number[]
- validation result
- submission status

API ENDPOINTS:
- GET /api/v1/krs/mata-kuliah
- POST /api/v1/krs/validate
- POST /api/v1/krs

Generate:
1. Main KRSForm component
2. MataKuliahCard sub-component
3. KRSSummary sub-component
4. API service functions (krsApi.ts)
5. Type definitions
6. Usage example
7. Test cases
```

---

### 4️⃣ Database Agent

**Role:** Design database schemas, optimize queries, create migrations

**Capabilities:**
- Design database schemas
- Create Prisma models
- Write complex queries
- Optimize performance
- Generate migrations

**Prompt Template:**
```markdown
You are a Database Expert specializing in PostgreSQL and Prisma ORM.

PROJECT CONTEXT:
- Database: PostgreSQL 15
- ORM: Prisma 5
- Requirements: ACID compliance, high performance

TASK: [Specific database task]

REQUIREMENTS:
- Follow database normalization principles
- Add proper indexes
- Include constraints
- Add triggers where needed
- Optimize for read/write patterns
- Include audit trail
- Support soft deletes

Please provide:
1. Complete Prisma schema
2. Migration SQL
3. Index strategy
4. Trigger functions (if needed)
5. Query optimization tips
6. Sample queries
```

**Example: Design KRS Schema**

**Prompt:**
```markdown
TASK: Design complete database schema for KRS (Kartu Rencana Studi) module

ENTITIES NEEDED:
1. mahasiswa (students)
2. mata_kuliah (courses)
3. kelas (classes)
4. krs (student course registration)
5. periode_akademik (academic period)
6. prasyarat_mk (course prerequisites)

RELATIONSHIPS:
- mahasiswa 1:N krs
- kelas 1:N krs
- mata_kuliah 1:N kelas
- mata_kuliah M:N prasyarat_mk (self-referencing)

BUSINESS RULES:
- KRS must be approved by dosen wali
- Check kuota before allowing registration
- Auto-increment/decrement kelas.terisi
- Support soft delete
- Audit all changes

Generate:
1. Complete Prisma schema
2. Indexes for optimization
3. Triggers for auto-updates
4. Migration SQL
5. Sample queries for common operations
```

---

### 5️⃣ Testing Agent

**Role:** Generate test cases, write test code, ensure coverage

**Capabilities:**
- Generate unit tests
- Create integration tests
- Write E2E test scenarios
- Generate test data
- Review test coverage

**Prompt Template:**
```markdown
You are a QA Engineer & Testing Expert specializing in Jest, Vitest, and Playwright.

PROJECT CONTEXT:
- Backend Testing: Jest + Supertest
- Frontend Testing: Vitest + React Testing Library
- E2E Testing: Playwright
- Target Coverage: >80%

TASK: [Specific testing task]

CODE TO TEST:
[Paste code here]

REQUIREMENTS:
- Write comprehensive test cases
- Cover edge cases
- Test error scenarios
- Include positive & negative tests
- Use proper mocking
- Follow AAA pattern (Arrange-Act-Assert)

Please provide:
1. Complete test suite
2. Test data/fixtures
3. Mocking strategy
4. Coverage analysis
5. Edge cases covered
```

**Example: Test KRS Validation Service**

**Prompt:**
```markdown
TASK: Generate comprehensive test suite for KRSValidationService

SERVICE CODE:
[Paste KRSValidationService code]

TEST SCENARIOS:
1. Prasyarat validation
   - Should pass if prerequisites met
   - Should fail if prerequisites not met
   - Should check minimum grade requirement
   
2. Jadwal bentrok
   - Should pass if no conflicts
   - Should detect time overlap
   - Should handle different days
   
3. Kuota validation
   - Should pass if seats available
   - Should fail if class full
   - Should handle concurrent registrations

4. Max SKS validation
   - Should allow based on IPK
   - Should reject if exceeding limit
   - Should handle edge IPK values

5. Pembayaran check
   - Should pass if paid
   - Should fail if unpaid
   - Should check specific payment types

Generate:
1. Complete Jest test file
2. Mock data setup
3. Test helpers
4. All test cases with descriptions
5. Edge cases
```

---

### 6️⃣ Documentation Agent

**Role:** Generate documentation, API docs, code comments, user guides

**Capabilities:**
- Generate API documentation
- Write code comments
- Create user guides
- Generate README files
- Write inline documentation

**Prompt Template:**
```markdown
You are a Technical Writer specializing in developer documentation.

PROJECT CONTEXT:
- Documentation Style: Clear, concise, example-driven
- Audience: [Developers/End Users/Both]
- Format: [Markdown/OpenAPI/JSDoc]

TASK: [Specific documentation task]

CODE/API:
[Paste code or API details]

REQUIREMENTS:
- Clear and concise language
- Include examples
- Cover edge cases
- Add troubleshooting tips
- Follow documentation standards
- Include diagrams where helpful

Please provide:
1. Complete documentation
2. Code examples
3. Common use cases
4. Error handling examples
5. Best practices
```

**Example: Generate API Documentation**

**Prompt:**
```markdown
TASK: Create comprehensive API documentation for KRS endpoints

ENDPOINTS:
1. GET /api/v1/krs/mata-kuliah
2. POST /api/v1/krs/validate
3. POST /api/v1/krs
4. GET /api/v1/krs
5. DELETE /api/v1/krs/:id

For each endpoint, provide:
- Description
- Authentication required
- Request parameters
- Request body (with examples)
- Response format (success & error)
- Status codes
- Error codes
- Example requests (curl)
- Example responses
- Common errors & solutions

Format: OpenAPI 3.0 (Swagger)
```

---

### 7️⃣ Security Agent

**Role:** Review code security, find vulnerabilities, suggest fixes

**Capabilities:**
- Security code review
- Vulnerability detection
- Security best practices
- OWASP compliance check
- Penetration testing guidance

**Prompt Template:**
```markdown
You are a Security Expert specializing in web application security.

PROJECT CONTEXT:
- Tech Stack: Node.js, React, PostgreSQL
- Security Standards: OWASP Top 10 compliance
- Authentication: JWT

TASK: Review code for security vulnerabilities

CODE TO REVIEW:
[Paste code]

REVIEW FOR:
- SQL Injection
- XSS vulnerabilities
- CSRF protection
- Authentication flaws
- Authorization issues
- Data exposure
- Input validation
- Rate limiting
- Sensitive data handling
- Dependency vulnerabilities

Please provide:
1. Identified vulnerabilities (severity: Critical/High/Medium/Low)
2. Explanation of each issue
3. Code fix recommendations
4. Prevention strategies
5. Additional security measures
```

**Example: Security Review**

**Prompt:**
```markdown
TASK: Security review of authentication system

CODE:
[Paste auth.controller.ts, auth.service.ts, auth.middleware.ts]

Check for:
1. Password security (hashing, salt, rounds)
2. JWT implementation (secret, expiry, refresh)
3. Rate limiting on login
4. SQL injection in queries
5. XSS in user inputs
6. Session management
7. Token storage
8. Error messages (info disclosure)
9. CORS configuration
10. Input validation

Provide:
- Security score (1-10)
- Critical issues with fixes
- Recommendations for improvements
- Compliance with OWASP Top 10
```

---

### 8️⃣ DevOps Agent

**Role:** Setup deployment, CI/CD, infrastructure, monitoring

**Capabilities:**
- Docker configuration
- CI/CD pipeline setup
- Server configuration
- Monitoring setup
- Backup strategies

**Prompt Template:**
```markdown
You are a DevOps Engineer specializing in Node.js deployment and CI/CD.

PROJECT CONTEXT:
- Application: Node.js + React
- Database: PostgreSQL
- Cache: Redis
- Server: Ubuntu 22.04
- CI/CD: GitHub Actions

TASK: [Specific DevOps task]

REQUIREMENTS:
- Production-ready setup
- Security best practices
- Automated deployment
- Monitoring & logging
- Backup strategy
- Scalability considerations

Please provide:
1. Complete configuration files
2. Step-by-step setup guide
3. Security checklist
4. Monitoring setup
5. Troubleshooting guide
```

**Example: Setup CI/CD Pipeline**

**Prompt:**
```markdown
TASK: Create complete CI/CD pipeline for Portal Akademik

REQUIREMENTS:
1. On push to main branch:
   - Run linting
   - Run tests
   - Build Docker images
   - Push to registry
   - Deploy to production
   - Run smoke tests

2. On pull request:
   - Run linting
   - Run tests
   - Check code coverage

3. Security:
   - Scan dependencies
   - Check for secrets in code

4. Notifications:
   - Send to Slack on success/failure

Generate:
1. .github/workflows/ci.yml
2. .github/workflows/deploy.yml
3. Dockerfile (backend)
4. Dockerfile (frontend)
5. docker-compose.yml
6. Deployment script
7. Rollback procedure
```

---

## 📚 Agent Prompts Library

### Quick Prompts Collection

#### 🔧 Code Generation

**Generate CRUD API:**
```markdown
Generate complete CRUD API for [Entity Name] with:
- Prisma model
- Service layer with business logic
- Controller with error handling
- Routes with authentication middleware
- Input validation (Zod)
- Unit tests
- API documentation

Fields: [list fields with types]
Business rules: [list rules]
```

**Generate React Component:**
```markdown
Generate React component for [Component Name] with:
- TypeScript
- Props interface
- State management (if needed)
- API integration (TanStack Query)
- Form validation (React Hook Form + Zod)
- Loading & error states
- shadcn/ui components
- Unit tests
- Accessibility

Features: [list features]
```

**Generate Database Migration:**
```markdown
Generate Prisma migration for:
- Add [table/column]
- Relationships: [describe]
- Indexes: [list]
- Constraints: [list]

Include:
1. Migration SQL
2. Rollback SQL
3. Impact analysis
```

#### 🧪 Testing

**Generate Test Suite:**
```markdown
Generate comprehensive test suite for:
[Paste code or function name]

Include:
- Happy path tests
- Edge cases
- Error scenarios
- Boundary conditions
- Mock data
- 80%+ coverage

Framework: [Jest/Vitest/Playwright]
```

#### 📖 Documentation

**Generate API Docs:**
```markdown
Generate OpenAPI documentation for:
[List endpoints]

Include for each:
- Summary & description
- Parameters
- Request/response examples
- Error codes
- Authentication
```

**Generate README:**
```markdown
Generate comprehensive README for [Module/Service] with:
- Overview
- Installation
- Configuration
- Usage examples
- API reference
- Troubleshooting
- Contributing guide
```

#### 🔒 Security Review

**Security Audit:**
```markdown
Perform security audit on:
[Paste code]

Check for OWASP Top 10:
1. Injection
2. Broken Authentication
3. Sensitive Data Exposure
4. XML External Entities (XXE)
5. Broken Access Control
6. Security Misconfiguration
7. XSS
8. Insecure Deserialization
9. Using Components with Known Vulnerabilities
10. Insufficient Logging & Monitoring

Provide:
- Severity ratings
- Fixes
- Prevention
```

#### ⚡ Performance Optimization

**Optimize Code:**
```markdown
Optimize this code for performance:
[Paste code]

Focus on:
- Database queries (N+1 problem)
- Memory usage
- Time complexity
- Caching opportunities
- Bundle size (frontend)

Provide:
- Optimized code
- Performance metrics
- Benchmarks
```

#### 🐛 Debugging

**Debug Issue:**
```markdown
I'm experiencing this issue:
[Describe problem]

Error message:
[Paste error]

Code:
[Paste relevant code]

Context:
- Environment: [development/production]
- Recent changes: [list]

Please help:
1. Identify root cause
2. Suggest fix
3. Prevention strategy
```

#### 🏗️ Architecture

**Design System Architecture:**
```markdown
Design architecture for [Feature/Module]:

Requirements:
- [List requirements]

Constraints:
- [List constraints]

Provide:
1. Architecture diagram
2. Component breakdown
3. Data flow
4. Technology choices
5. Scalability considerations
6. Security measures
```

---

## 🔄 Development Workflow with Agents

### Step-by-Step Process

#### Phase 1: Planning & Design
```markdown
AGENT: Project Manager Agent

INPUT:
Feature: KRS Module
Requirements: [from TODO.md]

OUTPUT:
1. Task breakdown
2. Dependency tree
3. Timeline estimate
4. Risk assessment
```

#### Phase 2: Database Design
```markdown
AGENT: Database Agent

INPUT:
- Entity requirements
- Business rules
- Relationships

OUTPUT:
1. Prisma schema
2. Migrations
3. Indexes
4. Triggers
```

#### Phase 3: Backend Development
```markdown
AGENT: Backend Development Agent

For each API endpoint:

INPUT:
- API specification
- Validation rules
- Business logic

OUTPUT:
1. Controller
2. Service
3. Routes
4. Validation
5. Tests
6. Documentation
```

#### Phase 4: Frontend Development
```markdown
AGENT: Frontend Development Agent

For each page/component:

INPUT:
- UI/UX requirements
- API endpoints
- State requirements

OUTPUT:
1. Components
2. Pages
3. State management
4. API integration
5. Tests
```

#### Phase 5: Testing
```markdown
AGENT: Testing Agent

INPUT:
- Code to test
- Test scenarios

OUTPUT:
1. Unit tests
2. Integration tests
3. E2E tests
4. Coverage report
```

#### Phase 6: Documentation
```markdown
AGENT: Documentation Agent

INPUT:
- Code
- APIs
- Features

OUTPUT:
1. API docs
2. Code comments
3. User guides
4. README
```

#### Phase 7: Security Review
```markdown
AGENT: Security Agent

INPUT:
- Complete codebase
- Authentication flow
- API endpoints

OUTPUT:
1. Vulnerability report
2. Fixes
3. Security checklist
```

#### Phase 8: Deployment
```markdown
AGENT: DevOps Agent

INPUT:
- Application code
- Infrastructure requirements

OUTPUT:
1. Docker configs
2. CI/CD pipeline
3. Deployment scripts
4. Monitoring setup
```

---

## 💡 Best Practices

### 1. Prompt Engineering Tips

✅ **Be Specific:**
```markdown
❌ BAD: "Create a login component"
✅ GOOD: "Create a React login component with email/password fields, validation using Zod, error handling, loading state, and forgot password link"
```

✅ **Provide Context:**
```markdown
Always include:
- Tech stack being used
- Project constraints
- Coding standards
- Expected output format
```

✅ **Include Examples:**
```markdown
Show examples of:
- Expected code style
- Similar existing code
- Desired output format
```

✅ **Iterate & Refine:**
```markdown
First prompt: Generate basic structure
Second prompt: Add validation
Third prompt: Add tests
Fourth prompt: Optimize performance
```

### 2. Code Review with AI

**Process:**
1. Generate code with agent
2. Review generated code manually
3. Ask agent to review its own code
4. Ask for improvements
5. Test thoroughly
6. Refactor if needed

**Example:**
```markdown
PROMPT: Review this code you generated and suggest improvements for:
- Performance
- Readability
- Maintainability
- Security
- Test coverage

[Paste generated code]
```

### 3. Incremental Development

**Strategy:**
```markdown
1. Generate basic structure
2. Add one feature at a time
3. Test each feature
4. Refactor
5. Move to next feature

Don't try to generate everything at once!
```

### 4. Version Control

**Commit Strategy:**
```markdown
# Commit message format
feat(module): [what agent generated]

Generated by: [Agent Name]
Prompt: [Brief prompt description]
Review status: [Pending/Reviewed/Tested]

# Example
feat(krs): add KRS validation service

Generated by: Backend Development Agent
Prompt: Create KRS validation with prasyarat check
Review status: Reviewed and tested
```

### 5. Documentation

**Keep Track:**
```markdown
Create AGENT_LOG.md:

## 2024-11-11
### Generated by Backend Agent
- KRS validation service
- Prompt: [link to prompt]
- Files: src/services/krsValidation.service.ts
- Tests: tests/unit/krsValidation.test.ts
- Status: ✅ Completed
- Issues: None

### Generated by Frontend Agent
- KRS form component
- Prompt: [link to prompt]
- Files: src/features/krs/KRSForm.tsx
- Status: ⏳ In Progress
- Issues: Need to add loading skeleton
```

### 6. Quality Assurance

**Checklist:**
```markdown
Before accepting AI-generated code:

✅ Does it compile without errors?
✅ Does it follow project conventions?
✅ Are all edge cases handled?
✅ Is error handling proper?
✅ Are there tests?
✅ Is it documented?
✅ Is it secure?
✅ Is it performant?
✅ Is it maintainable?
✅ Does it work as expected?
```

---

## 🎓 Advanced Techniques

### 1. Chain-of-Thought Prompting

**Technique:**
```markdown
Generate [something] by thinking through step-by-step:

1. First, analyze the requirements
2. Then, design the solution
3. Next, implement the code
4. Finally, add tests

Show your reasoning for each step.
```

**Example:**
```markdown
Generate KRS validation service using chain-of-thought:

1. Analyze: What validations are needed?
2. Design: How should the validation flow work?
3. Implement: Write the code with comments
4. Test: What test cases cover all scenarios?

Show your thought process for each step.
```

### 2. Few-Shot Learning

**Technique:**
```markdown
Here's an example of how we structure services in this project:

EXAMPLE 1:
[Paste example service]

EXAMPLE 2:
[Paste another example]

Now create a new service for [X] following the same pattern.
```

### 3. Role-Based Prompting

**Technique:**
```markdown
You are a [specific role] with [X] years of experience in [Y].
You are known for [specific strengths].
You always [specific practices].

Task: [specific task]
```

**Example:**
```markdown
You are a Senior React Developer with 8 years of experience in building scalable applications. You are known for writing clean, performant, and accessible code. You always write comprehensive tests and prioritize user experience.

Task: Create a complex form component for KRS selection
```

### 4. Constraint-Based Generation

**Technique:**
```markdown
Generate [X] with these STRICT constraints:
- Must use [technology]
- Cannot exceed [X] lines
- Must have [X] test coverage
- Must follow [pattern]
- Must complete in [X] time
```

### 5. Iterative Refinement

**Technique:**
```markdown
ITERATION 1: Generate basic structure
ITERATION 2: Add [feature]
ITERATION 3: Optimize [aspect]
ITERATION 4: Add comprehensive tests
ITERATION 5: Review and refactor

After each iteration, review and approve before proceeding.
```

---

## 🛠️ Agent Tools & Integrations

### Recommended AI Tools

| Tool | Best For | Integration |
|------|----------|-------------|
| **Claude (Sonnet)** | Complex reasoning, architecture design | API, Web |
| **GitHub Copilot** | Inline code completion | VS Code |
| **Cursor AI** | Full-file generation, refactoring | IDE |
| **ChatGPT (GPT-4)** | General development, brainstorming | API, Web |
| **Tabnine** | Code completion | IDE |
| **Codeium** | Free code completion | IDE |

### VS Code Extensions

```json
{
  "recommendations": [
    "github.copilot",
    "github.copilot-chat",
    "continue.continue",
    "anthropic.claude-dev",
    "codeium.codeium"
  ]
}
```

### CLI Tools

```bash
# Install AI CLI tools
npm install -g @anthropic-ai/claude-cli
npm install -g openai-cli

# Usage
claude "Generate a React component for [X]"
openai "Review this code for security issues: [code]"
```

---

## 📊 Productivity Metrics

### Measure AI Impact

```markdown
Track these metrics:

1. **Development Speed**
   - Before AI: [X] hours per feature
   - With AI: [Y] hours per feature
   - Improvement: [Z]%

2. **Code Quality**
   - Test coverage: [X]%
   - Bug rate: [Y] bugs per 1000 LOC
   - Code review issues: [Z] per PR

3. **Developer Satisfaction**
   - Learning curve
   - Confidence in code
   - Stress level

4. **Cost Savings**
   - Time saved
   - Resources saved
   - Faster delivery
```

---

## ⚠️ Limitations & Cautions

### What AI Agents CANNOT Do

❌ **Understand Full Business Context:**
- Agents don't know your specific business rules
- Always validate business logic manually

❌ **Make Architectural Decisions:**
- Agents can suggest, but you decide
- Don't blindly follow AI architecture

❌ **Guarantee Bug-Free Code:**
- Always test thoroughly
- Review all generated code

❌ **Replace Human Judgment:**
- Use AI to augment, not replace
- Critical decisions need human review

❌ **Handle Complex State:**
- Agents lose context in long conversations
- Break complex tasks into smaller ones

### Security Considerations

🔒 **Never Share:**
- API keys, passwords, secrets
- Proprietary business logic (without permission)
- Customer data
- Sensitive company information

🔒 **Always Review:**
- Authentication code
- Authorization logic
- Data validation
- SQL queries
- External API calls

---

## 📈 Success Stories

### Case Studies (Hypothetical)

#### Case 1: KRS Module Development
```markdown
Task: Develop complete KRS module
Time without AI: ~4 weeks
Time with AI: ~1.5 weeks
Speedup: 2.7x

Breakdown:
- Database design: 2 days → 4 hours (with Database Agent)
- API development: 1.5 weeks → 4 days (with Backend Agent)
- Frontend: 1.5 weeks → 5 days (with Frontend Agent)
- Testing: 1 week → 2 days (with Testing Agent)

Quality