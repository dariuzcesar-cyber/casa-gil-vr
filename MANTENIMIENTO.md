# Casa Gil — Bitácora 360°
Guía de mantenimiento y publicación

Remodelación de vivienda habitada en Placetas, Colima. Dirección y supervisión:
Arq. Sergio Díaz. Sitio hermano de Casa La Parota (misma plantilla y diseño).

## Estructura

```
index.html                      Landing principal (todo el CSS/JS va en línea)
assets/
  tour-theme.css                Tema oscuro compartido por TODOS los tours
  tour-enhance.js               Menú de escenas + nombres legibles (compartido)
  sergiologonegro.png           Logo (se fuerza a blanco con filter)
  sergio-retrato.jpg            Retrato del Arq. Sergio Díaz
scripts/subir-tiles.sh          Sube los tiles de una etapa a Cloudflare R2
tours/<etapa>/                  Salida de Marzipano + 3 líneas añadidas
```

Portada: video del render en `assets/render-casa-gil.mp4` (si no existe, se ve el
degradado de respaldo). Primer avance: `tours/septiembre-2026/`.

## Publicar una etapa nueva

1. Exportar el recorrido con Marzipano Tool a `tours/<mes>-<año>/`.
2. En el `index.html` de ese tour, añadir **tres líneas** (idénticas a Casa La Parota):

   En `<head>`, después de `<link rel="stylesheet" href="style.css">`:
   ```html
   <link rel="stylesheet" href="../../assets/tour-theme.css">
   ```
   Antes de `<script src="index.js"></script>`:
   ```html
   <script src="../../assets/tour-enhance.js"></script>
   ```
   Antes de `</body>`, la marca de agua:
   ```html
   <div class="tour-watermark" aria-hidden="true">
     <img src="../../assets/sergiologonegro.png" alt="">
     <span class="wm-label">Dirección de Obra<br>Arq. Sergio Díaz</span>
   </div>
   ```
   Más sencillo: copiar el `index.html` de un tour ya terminado de Casa La
   Parota y cambiar el título.
3. En `tours/<etapa>/index.js` apuntar los tiles a R2:
   ```js
   var urlPrefix = "https://tiles.dariuzph.com/casa-gil/<mes>-<año>";
   ```
4. Subir los tiles **antes** del push (ver `DEPLOY.md`):
   `scripts/subir-tiles.sh <mes>-<año>`
5. En `SITE_CONFIG.months` de la raíz marcar la etapa:
   ```js
   { slug:'octubre-2026', label:'Octubre', year:'2026',
     available:true, scenes:NN, date:'DD Mes 2026' },
   ```
   y subir `SITE_CONFIG.version`.

## Nombres de escena

`tour-enhance.js` agrupa por zona según la primera palabra del nombre
(`CLP<Zona>V<n>` → "Zona n"). Para zonas propias de Casa Gil (Cochera, Jardín,
Patio, Terraza, Recámara…) ampliar el objeto `ZONAS` en `assets/tour-enhance.js`.

## Al terminar la obra

Exportar el recorrido final a `tours/final-remodelacion/` y en `SITE_CONFIG`:
`mode: 'entregado'` y `finalTour.available: true`.

## Contactos en el código

- WhatsApp Arq. Sergio Díaz: `523121071335`
- WhatsApp Dariuz PH (autoría, pie de página): `523122247792`
