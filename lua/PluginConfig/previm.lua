local vg = vim.g

vg.previm_extra_libraries = {
  {
    name = "katex",
    files = {
      {
        type = "css",
        path = "_/js/extra/texmath.min.css",
        url = "https://cdn.jsdelivr.net/npm/markdown-it-texmath/css/texmath.min.css",
      },
      {
        type = "css",
        path = "_/css/extra/katex.min.css",
        url = "https://cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.css",
        code = {
          "renderMathInElement(document.body)",
        },
      },
      {
        type = "js",
        path = "_/js/extra/katex-auto-render.min.js",
        url = "https://cdn.jsdelivr.net/npm/katex@latest/dist/contrib/auto-render.min.js",
        code = {
          "renderMathInElement(document.body)",
        },
      },
      {
        type = "js",
        path = "_/js/extra/katex.min.js",
        url = "https://cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.js",
        code = {
          "document.querySelectorAll('pre code.language-katex').forEach(elem => {",
          "  const html = katex.renderToString(elem.innerText, {",
          "    displayMode: true,",
          "    output: 'html',",
          "    throwOnError: false,",
          "  })",
          "  const span = document.createElement('span')",
          "  span.innerHTML = html",
          "  elem.parentNode.replaceWith(span)",
          "})",
          "document.querySelectorAll('.inlkatex').forEach(elem => {",
          "  const html = katex.renderToString(elem.innerText, {",
          "    output: 'html',",
          "    throwOnError: false,",
          "  })",
          "  const span = document.createElement('span')",
          "  span.innerHTML = html",
          "  elem.replaceWith(span)",
          "})",
        },
      },
    },
  },
}
