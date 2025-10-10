# Aktuelles Pandoc inkl. LaTeX (für PDF)
FROM pandoc/latex:3.1

# Python + MkDocs + mkdocs-combine installieren
RUN apt-get update && apt-get install -y python3 python3-pip && \
    pip3 install --no-cache-dir mkdocs==1.6.0 mkdocs-combine==0.7.0 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /docs
# Reihenfolge: erst mkdocs.yml, dann Inhalte
COPY mkdocs.yml ./
COPY docs/ ./docs

# 1) Alle Seiten zu einer Markdown-Datei kombinieren
# 2) PDF mit xelatex erzeugen
# 3) Statisches Site-Build
RUN mkdocscombine -o merged.md && \
    pandoc --toc --pdf-engine=xelatex -f markdown+grid_tables+table_captions \
           -o Dokumentation.pdf merged.md && \
    mkdocs build -d site

EXPOSE 8000
CMD ["python3", "-m", "http.server", "8000", "--directory", "site"]
