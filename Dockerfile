# =============================================================================
# Dockerfile – Jenkins LTS con Java 17 + Maven
# Proyecto : hello-demo (Spring Boot 3.3.2 / Java 17 / Maven)
# =============================================================================

FROM jenkins/jenkins:lts

# ── Instalación de dependencias del sistema ──────────────────────────────────
# Necesitamos root para instalar paquetes con apt-get
USER root

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jdk \
        maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ── Variables de entorno para Java y Maven ───────────────────────────────────
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV MAVEN_HOME=/usr/share/maven
ENV PATH="${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}"

# ── Plugin de Pipelines (workflow-aggregator) ────────────────────────────────
# Instala el plugin en tiempo de build para que esté disponible desde el inicio
RUN jenkins-plugin-cli --plugins \
        workflow-aggregator:latest \
        git:latest \
        maven-plugin:latest

# ── Volvemos al usuario jenkins por seguridad ────────────────────────────────
USER jenkins

# Exponer puertos: 8080 (UI) y 50000 (agentes JNLP)
EXPOSE 8080 50000
