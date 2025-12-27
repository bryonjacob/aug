---
name: feature-walkthrough
description: Generate polished walkthrough video from Playwright test suite
argument-hint: <feature-description> [--output <dir>]
---

# Feature Walkthrough - Video Generation from Playwright Tests

Generate a polished demo video from a suite of thematically connected Playwright tests.

**Purpose**: Transform automated test runs into watchable walkthrough videos with title cards, slowed footage, and professional concatenation. Perfect for feature demos, documentation, or stakeholder presentations.

---

## Prerequisites Check

Before proceeding, verify required tools:

```bash
which ffmpeg && which convert && npx playwright --version
```

If any are missing, inform the user and provide installation guidance.

---

## Workflow

**Use the `feature-walkthrough` skill for detailed implementation guidance.**

### Phase 1: Parse Input & Configure

**Use TodoWrite to track progress through these steps:**

1. **Parse user input**
   - Feature description (what are we demoing?)
   - Test pattern (spec file, grep pattern, or test names)
   - Output directory (required - where to put final video)
   - Output filename (optional - derive from feature name if not provided)

2. **Discover available tests**
   ```bash
   npx playwright test --list {test-pattern}
   ```
   - Show user the tests that will be recorded
   - Confirm selection before proceeding

3. **Gather video configuration**
   - Main title and subtitle for intro card
   - Per-test titles (offer to auto-generate from test names)
   - Slowdown factor (default: 10x)
   - Title card duration (default: 3 seconds)

4. **Create session**
   - Generate session-id slug: `{feature-name}-walkthrough`
   - Create `/tmp/walkthrough/{session-id}/` directory
   - Write `config.json` with all settings

### Phase 2: Record Tests

1. **Generate temporary Playwright config**
   - Enable `video: 'on'` for all tests
   - Set sequential execution (`workers: 1`, `fullyParallel: false`)
   - Output to `/tmp/walkthrough/{session-id}/recordings/`

2. **Run tests**
   ```bash
   npx playwright test {test-pattern} --config=/tmp/walkthrough/{session-id}/playwright-video.config.ts
   ```

3. **Verify recordings**
   - Check each test directory for `video.webm`
   - Report success/failure for each test
   - Continue with available recordings

### Phase 3: Process Videos

1. **Detect video dimensions**
   - Run ffprobe on first video
   - Store width/height for title card generation

2. **Convert WebM to MP4**
   - Process each recording
   - Report conversion progress

3. **Create title cards**
   - Main intro card (larger text)
   - Section cards for each test
   - Match video dimensions exactly

4. **Convert title cards to video clips**
   - Loop each image for specified duration
   - Match frame rate (30fps)

5. **Slow down test recordings**
   - Apply slowdown factor
   - Report new duration per clip

### Phase 4: Concatenate

1. **Build concat manifest**
   - Order: main title, then alternating section titles + slowed clips

2. **Run ffmpeg concat**
   - Use medium preset for good quality/speed balance
   - CRF 23 for reasonable file size

3. **Copy to output directory**
   - Final video to user's specified location
   - Verify file exists and report size

### Phase 5: Complete

1. **Report results**
   ```
   Feature Walkthrough Complete

   Output: {OUTPUT_DIR}/{FILENAME}.mp4
   Duration: {DURATION}
   Tests recorded: {COUNT}

   Working files: /tmp/walkthrough/{session-id}/
   (Delete when satisfied with output)
   ```

2. **Preserve working directory**
   - Keep for debugging/re-processing
   - User can manually delete

---

## Skills to Use

- `feature-walkthrough` - **Required.** Invoke for detailed ffmpeg/ImageMagick commands and configuration options.

---

## Quality Checks

Before marking complete:
- [ ] All requested tests ran (report any failures)
- [ ] Video recordings captured successfully
- [ ] Title cards generated at correct dimensions
- [ ] All clips concatenated without errors
- [ ] Final video plays correctly
- [ ] Output file exists in user's specified directory
- [ ] Duration and file size reported

---

## Example Usage

**Basic usage:**
```bash
/feature-walkthrough for the new onboarding feature, output to ~/Videos
```

**With specific test file:**
```bash
/feature-walkthrough tests/integration/checkout.spec.ts --output ~/demos
```

**With grep pattern:**
```bash
/feature-walkthrough --grep "authentication" --output ./docs/videos
```

**With custom title:**
```bash
/feature-walkthrough for payment processing, title "Payment Flow Demo", output to ~/presentations
```

---

## Interactive Flow Example

```
User: /feature-walkthrough for the new onboarding feature, put the output in ~/output

Claude: Let me find the relevant tests for the onboarding feature.

[Runs: npx playwright test --list --grep onboarding]

Found 5 tests in tests/integration/onboarding.spec.ts:
1. should show phone entry form
2. should validate phone number format
3. should send OTP successfully
4. should verify identity information
5. should display approval screen

Proceed with recording these tests?

User: yes

Claude: What should the main title be?

User: "Onboarding Flow Demo"

Claude: And a subtitle? (optional)

User: "Credit Card Application Walkthrough"

Claude:
[Creates session at /tmp/walkthrough/onboarding-flow-demo/]
[Generates Playwright config with video enabled]
[Runs tests - shows progress]

Test Recording Progress:
 Phone entry form - recorded (2.3s)
 Phone validation - recorded (1.8s)
 OTP sending - recorded (3.1s)
 Identity verification - recorded (4.2s)
 Approval screen - recorded (2.1s)

[Detects video dimensions: 1280x720]
[Creates title cards]
[Slows videos 10x]
[Concatenates...]

Feature Walkthrough Complete

Output: ~/output/onboarding-flow-demo.mp4
Duration: 3 minutes 45 seconds
Tests recorded: 5/5

Working files preserved at: /tmp/walkthrough/onboarding-flow-demo/
```

---

## Error Recovery

**If tests fail:**
- Report which tests failed
- Ask if user wants to proceed with successful recordings only
- Failed test videos still captured (shows what went wrong)

**If ffmpeg fails:**
- Report specific error
- Check if all input files exist
- Suggest running individual commands for debugging

**If ImageMagick fails:**
- Check font availability
- Fall back to default fonts
- Report font substitution
