export const isHtmlOnly = html => {
  const stripped = html.replace(/<\/?[^>]+>/gi, '').trim();
  return stripped.length === 0;
};
