---
name: configuring-java-stack
description: Use when setting up Java projects with modern tooling - provides Maven, JUnit 5, Spotless formatting, SpotBugs linting, and JaCoCo coverage with 0.0.0.0 binding for Docker compatibility
---

# Configuring Java Stack

## Overview

Modern Java toolchain: **Maven** (build tool) + **JUnit 5** (testing) + **Spotless** (formatting) + **SpotBugs** (static analysis) + **JaCoCo** (coverage).

## Toolchain

| Tool | Purpose | Version |
|------|---------|---------|
| **Maven** | Build & dependency management | 3.9+ |
| **Java** | Language | 21 (LTS) |
| **JUnit 5** | Testing framework | 5.10+ |
| **Spotless** | Code formatter (Google Java Format) | 2.43+ |
| **SpotBugs** | Static analysis / linting | 4.8+ |
| **JaCoCo** | Code coverage | 0.8.11+ |
| **Maven Surefire** | Test runner (with slow test reporting) | 3.2+ |
| **Checkstyle** | Basic complexity check | 10.12+ |
| **PMD** | Detailed complexity analysis | 7.0+ |
| **cloc** | Lines of code counter | - |

## Quick Reference

```bash
# Setup
mvn clean install
brew install cloc  # or: sudo apt install cloc (for LOC counting)

# Quality checks
mvn spotless:apply          # Format code
mvn spotless:check          # Check formatting
mvn spotbugs:check          # Lint/static analysis
mvn compile                 # Type check (compile)
mvn test                    # Run tests (shows slowest tests)
mvn verify                  # Run tests with coverage
mvn checkstyle:check        # Basic complexity check
mvn pmd:pmd                 # Detailed complexity analysis
cloc src/ --by-file --include-lang=Java --quiet | sort -rn | head -20  # LOC
```

## Web Service Configuration

**Critical: Always bind to 0.0.0.0 (not 127.0.0.1) for Docker compatibility.**

**Spring Boot application.properties:**
```properties
server.address=0.0.0.0
server.port=${PORT:8080}
```

**Standalone server:**
```java
public class Server {
    public static void main(String[] args) {
        String host = System.getenv().getOrDefault("HOST", "0.0.0.0");
        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));

        // Your server setup
        server.bind(host, port);
    }
}
```

## pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>my-project</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <junit.version>5.10.1</junit.version>
        <spotbugs.version>4.8.3</spotbugs.version>
        <jacoco.version>0.8.11</jacoco.version>
    </properties>

    <dependencies>
        <!-- JUnit 5 -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>${junit.version}</version>
            <scope>test</scope>
        </dependency>

        <!-- AssertJ for fluent assertions -->
        <dependency>
            <groupId>org.assertj</groupId>
            <artifactId>assertj-core</artifactId>
            <version>3.25.1</version>
            <scope>test</scope>
        </dependency>

        <!-- Mockito for mocking -->
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>5.8.0</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-junit-jupiter</artifactId>
            <version>5.8.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- Maven Compiler Plugin -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.12.1</version>
                <configuration>
                    <compilerArgs>
                        <arg>-Xlint:all</arg>
                        <arg>-Werror</arg>
                    </compilerArgs>
                </configuration>
            </plugin>

            <!-- Spotless for formatting -->
            <plugin>
                <groupId>com.diffplug.spotless</groupId>
                <artifactId>spotless-maven-plugin</artifactId>
                <version>2.43.0</version>
                <configuration>
                    <java>
                        <googleJavaFormat>
                            <version>1.19.2</version>
                            <style>GOOGLE</style>
                        </googleJavaFormat>
                        <removeUnusedImports />
                        <trimTrailingWhitespace />
                        <endWithNewline />
                    </java>
                </configuration>
            </plugin>

            <!-- SpotBugs for static analysis -->
            <plugin>
                <groupId>com.github.spotbugs</groupId>
                <artifactId>spotbugs-maven-plugin</artifactId>
                <version>4.8.3.0</version>
                <configuration>
                    <effort>Max</effort>
                    <threshold>Low</threshold>
                    <failOnError>true</failOnError>
                    <xmlOutput>true</xmlOutput>
                </configuration>
                <executions>
                    <execution>
                        <goals>
                            <goal>check</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>

            <!-- Maven Surefire for running tests -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.3</version>
                <configuration>
                    <reportFormat>plain</reportFormat>
                    <consoleOutputReporter>
                        <disable>false</disable>
                    </consoleOutputReporter>
                    <statelessTestsetReporter implementation="org.apache.maven.plugin.surefire.extensions.junit5.JUnit5Xml30StatelessReporter">
                        <usePhrasedTestSuiteClassName>true</usePhrasedTestSuiteClassName>
                        <usePhrasedTestCaseClassName>true</usePhrasedTestCaseClassName>
                        <usePhrasedTestCaseMethodName>true</usePhrasedTestCaseMethodName>
                    </statelessTestsetReporter>
                </configuration>
            </plugin>

            <!-- JaCoCo for coverage -->
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>${jacoco.version}</version>
                <executions>
                    <execution>
                        <id>prepare-agent</id>
                        <goals>
                            <goal>prepare-agent</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>report</id>
                        <phase>test</phase>
                        <goals>
                            <goal>report</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>check</id>
                        <goals>
                            <goal>check</goal>
                        </goals>
                        <configuration>
                            <rules>
                                <rule>
                                    <element>BUNDLE</element>
                                    <limits>
                                        <limit>
                                            <counter>LINE</counter>
                                            <value>COVEREDRATIO</value>
                                            <minimum>0.80</minimum>
                                        </limit>
                                        <limit>
                                            <counter>BRANCH</counter>
                                            <value>COVEREDRATIO</value>
                                            <minimum>0.80</minimum>
                                        </limit>
                                    </limits>
                                </rule>
                            </rules>
                        </configuration>
                    </execution>
                </executions>
            </plugin>

            <!-- Checkstyle for basic complexity check -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-checkstyle-plugin</artifactId>
                <version>3.3.1</version>
                <configuration>
                    <configLocation>google_checks.xml</configLocation>
                    <consoleOutput>true</consoleOutput>
                    <failsOnError>true</failsOnError>
                    <violationSeverity>warning</violationSeverity>
                </configuration>
                <executions>
                    <execution>
                        <goals>
                            <goal>check</goal>
                        </goals>
                    </execution>
                </executions>
                <dependencies>
                    <dependency>
                        <groupId>com.puppycrawl.tools</groupId>
                        <artifactId>checkstyle</artifactId>
                        <version>10.12.7</version>
                    </dependency>
                </dependencies>
            </plugin>

            <!-- PMD for detailed complexity analysis -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-pmd-plugin</artifactId>
                <version>3.21.2</version>
                <configuration>
                    <targetJdk>21</targetJdk>
                    <printFailingErrors>true</printFailingErrors>
                    <rulesets>
                        <ruleset>/rulesets/java/quickstart.xml</ruleset>
                    </rulesets>
                </configuration>
                <executions>
                    <execution>
                        <goals>
                            <goal>check</goal>
                            <goal>cpd-check</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

## Project Structure

```
my-project/
├── pom.xml
├── justfile
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── example/
│   │   │           └── App.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/
│           └── com/
│               └── example/
│                   └── AppTest.java
└── target/                 # Generated by Maven (add to .gitignore)
```

## justfile Integration

```just
set shell := ["bash", "-uc"]

default:
    @just --list

# Install dependencies
dev:
    mvn clean install -DskipTests

# Format code
format:
    mvn spotless:apply

# Lint code
lint:
    mvn spotbugs:check

# Type check (compile)
typecheck:
    mvn clean compile

# Run tests
test:
    mvn test

# Run tests in watch mode (requires maven-exec-plugin)
test-watch:
    mvn fizzed-watcher:run

# Run tests with coverage
coverage:
    mvn clean verify

# Check complexity (detailed analysis)
complexity:
    mvn pmd:pmd

# Count lines of code (largest files first)
loc N="20":
    @echo "📊 Lines of code by file (largest first, showing {{N}}):"
    @cloc src/ --by-file --include-lang=Java --quiet | sort -rn | head -{{N}}

# Build project
build:
    mvn clean package

# Run all quality checks
check-all: format lint typecheck coverage
    @echo "✅ All checks passed"

# Clean generated files
clean:
    mvn clean
```

## Quality Thresholds

- **Coverage:** 80% minimum (lines and branches)
- **Compiler warnings:** Zero warnings (treat warnings as errors)
- **Static analysis:** Zero SpotBugs violations
- **Formatting:** 100% compliance with Google Java Format
- **Complexity:** Max 10 (cyclomatic, enforced by Checkstyle)

## Common Patterns

### Testing with JUnit 5

```java
package com.example;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.BeforeEach;
import static org.assertj.core.api.Assertions.*;

class CalculatorTest {
    private Calculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new Calculator();
    }

    @Test
    @DisplayName("Should add two positive numbers")
    void shouldAddTwoPositiveNumbers() {
        int result = calculator.add(2, 3);
        assertThat(result).isEqualTo(5);
    }

    @Test
    @DisplayName("Should throw exception on division by zero")
    void shouldThrowExceptionOnDivisionByZero() {
        assertThatThrownBy(() -> calculator.divide(10, 0))
            .isInstanceOf(ArithmeticException.class)
            .hasMessage("Division by zero");
    }
}
```

### Mocking with Mockito

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import static org.mockito.Mockito.*;
import static org.assertj.core.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock
    private UserRepository repository;

    @Test
    void shouldFindUserById() {
        User user = new User("1", "Alice");
        when(repository.findById("1")).thenReturn(Optional.of(user));

        UserService service = new UserService(repository);
        Optional<User> result = service.findById("1");

        assertThat(result).isPresent();
        assertThat(result.get().getName()).isEqualTo("Alice");
        verify(repository).findById("1");
    }
}
```

### Parameterized Tests

```java
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import static org.assertj.core.api.Assertions.*;

class MathUtilsTest {
    @ParameterizedTest
    @CsvSource({
        "0, 1, 1",
        "1, 2, 3",
        "49, 51, 100",
        "1, 100, 101"
    })
    void shouldAddNumbers(int a, int b, int expected) {
        int result = MathUtils.add(a, b);
        assertThat(result).isEqualTo(expected);
    }
}
```

## Maven Watch Mode (Optional)

For test watch mode, add this plugin to `pom.xml`:

```xml
<plugin>
    <groupId>com.fizzed</groupId>
    <artifactId>fizzed-watcher-maven-plugin</artifactId>
    <version>1.0.6</version>
    <configuration>
        <watches>
            <watch>
                <directory>src/main/java</directory>
            </watch>
            <watch>
                <directory>src/test/java</directory>
            </watch>
        </watches>
        <goals>
            <goal>test</goal>
        </goals>
    </configuration>
</plugin>
```

## .gitignore

```gitignore
# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties
dependency-reduced-pom.xml
buildNumber.properties

# IDE
.idea/
*.iml
.vscode/
.classpath
.project
.settings/

# OS
.DS_Store
Thumbs.db

# Logs
*.log
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Binding to 127.0.0.1 | Bind to **0.0.0.0** for Docker |
| Not setting Java version | Set `maven.compiler.source` and `target` to 21 |
| Missing coverage config | Configure JaCoCo with 80% threshold |
| Skipping static analysis | Add SpotBugs plugin with `failOnError=true` |
| No formatter config | Add Spotless with Google Java Format |
| Using JUnit 4 | Use **JUnit 5** (jupiter) |

## Installation Requirements

**System-wide (one-time setup):**
```bash
# Java 21 (LTS)
brew install openjdk@21  # macOS
# or: sudo apt install openjdk-21-jdk  # Linux

# Maven
brew install maven  # macOS
# or: sudo apt install maven  # Linux

# cloc for LOC measurement
brew install cloc  # macOS
# or: sudo apt install cloc  # Linux

# just for justfile commands
brew install just  # macOS
# or: cargo install just  # Linux

# Verify
java -version    # Should show 21.x
mvn -version     # Should show 3.9+
cloc --version
just --version
```

## IDE Setup

**IntelliJ IDEA:**
- Import as Maven project
- Enable annotation processing
- Set project SDK to Java 21
- Configure Spotless to run on save

**VS Code:**
- Install "Extension Pack for Java"
- Install "Test Runner for Java"
- Configure Spotless to run on save

## Reference Documentation

- **Maven:** https://maven.apache.org/guides/
- **JUnit 5:** https://junit.org/junit5/docs/current/user-guide/
- **AssertJ:** https://assertj.github.io/doc/
- **Mockito:** https://javadoc.io/doc/org.mockito/mockito-core/
- **Spotless:** https://github.com/diffplug/spotless/tree/main/plugin-maven
- **SpotBugs:** https://spotbugs.github.io/
- **JaCoCo:** https://www.jacoco.org/jacoco/trunk/doc/
