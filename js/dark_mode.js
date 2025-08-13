const checkbox = document.getElementById('theme-toggle');
const themeParam = new URLSearchParams(window.location.search).get('theme');
const root = document.documentElement;

function setTheme(theme) {
  root.setAttribute('data-theme', theme);
  checkbox.checked = theme === 'dark';
  const url = new URL(window.location.href);
  url.searchParams.set('theme', theme);
  window.history.replaceState({}, '', url);
}

// Init theme from ?theme=...
if (themeParam === 'dark' || themeParam === 'light') {
  setTheme(themeParam);
}

// Update theme on toggle
checkbox.addEventListener('change', () => {
  setTheme(checkbox.checked ? 'dark' : 'light');
});

// Inject theme param into all internal <a> links
document.addEventListener('click', (e) => {
  const a = e.target.closest('a[href]');
  if (!a || a.target === '_blank') return;

  const url = new URL(a.href, window.location.href);
  if (url.origin !== window.location.origin) return; // external link

  const currentTheme = root.getAttribute('data-theme');
  url.searchParams.set('theme', currentTheme);
  a.href = url.href;
});
