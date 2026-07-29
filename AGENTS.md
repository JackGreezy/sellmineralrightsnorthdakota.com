# Sell Mineral Rights North Dakota release rules

This project is a faithful ENERCON reference relabel for `sellmineralrightsnorthdakota.com`. Its visual system must retain the donor's real navigation, full-width editorial bands, image compositions, dark and green contrast sections, portfolio cards, typography, spacing, cadence, and footer geometry. Do not replace those structures with a generic stack of repeated cards.

The copy voice belongs only to this business. It is a western North Dakota owner-record briefing shaped by a fourth-generation ranch family's experience with mineral ownership and one family sale. It is not a reusable mineral-rights voice pack and must never be copied to another domain. Every future site needs its own domain-locked voice.

Public copy is written as a business, not a personal blog. Singular first-person narration (`I`, `me`, `my`, `mine`, and contractions) is prohibited in visible copy. Collective business language may be used sparingly when it is the clearest phrasing.

Release blockers:

- The homepage hero has exactly one visible, SEO-driven H1 and a working mapped hero image.
- Every content page has mapped local imagery; blank `src`, blank `srcset`, donor media, remote thumbnails, and miniature footer/media glitches are prohibited.
- Footer DOM contains zero `img`, `picture`, `svg`, `video`, `source`, `canvas`, or `iframe` elements.
- The street address is never rendered as text, metadata, schema, alt text, or form copy. It may appear only URL-encoded inside the single Google Maps embed on `/contact`.
- The contact form posts to the local `/api/contact` handler and routes to `northdakota@sellmineralrightsnorthdakota.com`.
- Homepage bands cover every shipped taxonomy and appear in importance order, never alphabetical source order.
- Both faithful-home machine gates and full-resolution donor-versus-built visual review must pass before git or deployment.
- Git work must occur inside this child repository only. Neighboring mineral-rights projects and the dirty fleet parent are out of scope.
