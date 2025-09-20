FROM silentstorm/pandoc-mkdocs:latest
WORKDIR /docs
COPY docs/ ./docs
COPY mkdocs.yml ./

# Generate a single Markdown file for the PDF
RUN mkdocscombine -o merged.md && \
    pandoc --toc --pdf-engine=xelatex -f markdown+grid_tables+table_captions \
          -o Dokumentation.pdf merged.md && \
    mkdocs build -d site

CMD ["python", "-m", "http.server", "8000", "--directory", "site"]
