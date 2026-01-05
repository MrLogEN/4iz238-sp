/**
 * Toggle visibility of daily log content
 * @param {string} id - The ID of the log content to toggle
 */
function toggleLog(id) {
    const content = document.getElementById(id);
    const icon = document.getElementById('icon-' + id);
    
    if (content.style.display === 'none') {
        content.style.display = 'block';
        icon.textContent = '▼';
    } else {
        content.style.display = 'none';
        icon.textContent = '▶';
    }
}

/**
 * Initialize the page - collapse all logs except the first one
 */
document.addEventListener('DOMContentLoaded', function() {
    const logs = document.querySelectorAll('.log-content');
    logs.forEach(function(log, index) {
        if (index > 0) {
            log.style.display = 'none';
            const icon = document.getElementById('icon-' + log.id);
            if (icon) icon.textContent = '▶';
        }
    });
    
    // Set progress bar widths based on data-progress attribute
    const goalItems = document.querySelectorAll('.goal-item[data-progress]');
    goalItems.forEach(function(item) {
        const progress = item.getAttribute('data-progress');
        if (progress) {
            item.style.setProperty('--progress', progress + '%');
        }
    });
});
