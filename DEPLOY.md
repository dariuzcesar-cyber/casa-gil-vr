# Casa Gil — Despliegue

Misma arquitectura que Casa La Parota: sitio estático en **Cloudflare Pages**
(conectado a GitHub) y tiles del 360° en **Cloudflare R2**.

## Tiles en R2
- Bucket compartido con Casa La Parota: `casa-la-parota-tiles`
- URL pública: `https://tiles.dariuzph.com/casa-gil/<etapa>/<escena>/...`
- `tours/*/tiles/` está en `.gitignore`: el repo solo lleva código, así el
  deploy queda muy por debajo del tope de 20 000 archivos de Pages.

## Primera publicación del sitio (una sola vez)
1. Crear el repo en GitHub (p. ej. `casa-gil-vr`) y conectarlo:
   ```bash
   cd ~/Desktop/CasaGilVR
   git remote add origin https://github.com/dariuzcesar-cyber/casa-gil-vr.git
   git push -u origin main
   ```
2. En Cloudflare: Workers & Pages → Create → Pages → conectar ese repo.
   Sin build command; directorio de salida: `/` (raíz).
3. Opcional: dominio propio para el sitio.

## Publicar una etapa nueva
1. Exportar a `tours/<mes>-<año>/` y aplicar el procedimiento de `MANTENIMIENTO.md`.
2. Subir tiles **antes** de hacer push:
   ```bash
   export R2_ACCESS_KEY_ID="..."        # token con Object Read & Write
   export R2_SECRET_ACCESS_KEY="..."
   scripts/subir-tiles.sh <mes>-<año>   # requiere rclone
   ```
3. Comprobar una URL de tile en `tiles.dariuzph.com/casa-gil/<mes>-<año>/...`.
4. Marcar la etapa en `SITE_CONFIG`, subir `version` y `git push origin main`.

## Caché
`_headers` obliga a revalidar HTML, datos del tour y archivos compartidos.
Subir `SITE_CONFIG.version` en cada despliegue para que el iframe no sirva un
recorrido anterior. Recarga dura para verificar: `Cmd + Shift + R`.

Nunca guardes claves de R2 en el repo ni las pegues en chats.
