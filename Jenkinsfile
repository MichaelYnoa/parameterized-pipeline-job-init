// =============================================================================
// Jenkinsfile – Pipeline CI/CD para hello-demo (Spring Boot / Java 17 / Maven)
// Stages: Build → Test → Check
// =============================================================================

pipeline {
    agent any

    // ── Herramientas disponibles en el contenedor ─────────────────────────
    // Maven y Java 17 ya están instalados en la imagen Docker, sin config extra.
    environment {
        MAVEN_OPTS = '-Xmx512m -Xms256m'
    }

    stages {

        // ── STAGE 1: BUILD ────────────────────────────────────────────────
        // Compila el proyecto y empaqueta el .jar omitiendo tests en esta fase.
        stage('Build') {
            steps {
                echo '📦 Compilando el proyecto con Maven...'
                sh 'mvn clean package -DskipTests=true --batch-mode'
                archiveArtifacts artifacts: 'target/hello-demo-*.jar', fingerprint: true
                echo '✅ Build completado. Artefacto archivado.'
            }
        }

        // ── STAGE 2: TEST ─────────────────────────────────────────────────
        // Ejecuta las pruebas unitarias e integración. Publica resultados JUnit.
        stage('Test') {
            steps {
                echo '🧪 Ejecutando pruebas de QA...'
                sh 'mvn test --batch-mode'
                junit(
                    testResults: 'target/surefire-reports/TEST-*.xml',
                    keepProperties: true,
                    keepTestNames: true,
                    allowEmptyResults: false
                )
                echo '✅ Tests ejecutados. Resultados publicados en Jenkins.'
            }
            post {
                failure {
                    echo '❌ Falló alguna prueba. Revisa el reporte JUnit.'
                }
            }
        }

        // ── STAGE 3: CHECK (Calidad de Código) ────────────────────────────
        // Verifica la calidad: análisis estático con maven-checkstyle-plugin
        // y validación de dependencias (OWASP o similar si se añade al pom).
        stage('Check') {
            steps {
                echo '🔍 Verificando calidad del código...'
                // Análisis de estilo de código
                sh 'mvn checkstyle:check --batch-mode -Dcheckstyle.failOnViolation=false'
                // Análisis de posibles bugs con SpotBugs (si está en pom.xml)
                // sh 'mvn spotbugs:check --batch-mode'
                // Validación del POM y dependencias
                sh 'mvn dependency:analyze --batch-mode || true'
                echo '✅ Check de calidad completado.'
            }
            post {
                always {
                    echo '📊 Reporte de calidad disponible en la consola de Jenkins.'
                }
            }
        }
    }

    // ── Acciones POST-PIPELINE ────────────────────────────────────────────
    post {
        success {
            echo '🚀 Pipeline completado exitosamente. El artefacto está listo para desplegar.'
        }
        failure {
            echo '💥 El Pipeline falló. Revisa los logs de cada stage.'
        }
        always {
            // Limpiar el workspace para no acumular archivos entre builds
            cleanWs()
        }
    }
}
