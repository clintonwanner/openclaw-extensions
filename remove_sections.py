import re

with open('skills-inventory.md', 'r') as f:
    lines = f.readlines()

# Find sections to remove
sections_to_remove = [
    '### 7. n8n Workflow Automation',
    '### 8. Clawddocs', 
    '### 9. Gog (Google Workspace CLI)',
    '### 12. Summarize'
]

output = []
i = 0
while i < len(lines):
    line = lines[i]
    
    # Check if this line starts a section to remove
    remove_section = False
    for section in sections_to_remove:
        if line.strip().startswith(section):
            remove_section = True
            break
    
    if remove_section:
        # Skip until next section or end of file
        while i < len(lines) and not (lines[i].strip().startswith('### ') and i > 0 and lines[i-1].strip() == '---'):
            i += 1
        # Skip the --- line before the next section
        if i < len(lines) and lines[i].strip() == '---':
            i += 1
        continue
    
    output.append(line)
    i += 1

# Write back
with open('skills-inventory.md', 'w') as f:
    f.writelines(output)

print(f"Removed sections: {sections_to_remove}")
print(f"Original lines: {len(lines)}, New lines: {len(output)}")
