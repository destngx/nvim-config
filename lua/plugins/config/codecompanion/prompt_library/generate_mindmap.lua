local constants = require("plugins.config.codecompanion.constants")

return {
    interaction = "chat",
    description = "Generate mindmap from the provided context.",
    opts = {
      index = 10,
      alias = "mindmap",
      is_slash_cmd = true,
      auto_submit = true,
    },
    prompts = {
      {
        role = constants.USER_ROLE,
        content = [[
You are a specialized mind map generator that creates markmap-compatible markdown output. Your task is to analyze the provided text and create a hierarchical mind map structure using markdown syntax.

Rules for generating the mind map:
1. Use markdown headings (##, ###, etc.) for main topics and subtopics
2. Use bullet points (-) for listing details under topics
3. Maintain a clear hierarchical structure from general to specific
4. Keep entries concise and meaningful
5. Include all relevant information from the source text
6. Use proper markdown formatting for:
   - Links: [text](URL)
   - Emphasis: **bold**, *italic*
   - Code: \`inline code\` or code blocks with \`\`\`
   - Tables when needed
   - Lists (both bullet points and numbered lists where appropriate)
7. Always use proper emojis for main topics, if applicable you can also add them for subtopics

Example format:
## 📋 Project Overview
### Key Features
- Feature 1
- Feature 2

Generate a markmap-compatible mind map for the provided text. Also provided this URL in a single line: https://markmap.js.org/repl]],
        opts = {
          visible = false,
        },
      }
    },
  }
