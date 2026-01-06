function listSitesURL(itemsite, itemsiteURL) {
    // console.log(itemsite, itemsiteURL);
    dataUrl(itemsiteURL, itemsite);
}

function toggleThemeMenu() {
    let themeMenu = document.querySelector('#theme-menu');
    var bsTheme = localStorage.getItem("bsTheme");
    let prevCss = "bi-sun-fill";
    if (bsTheme) {
        document.documentElement.setAttribute('data-bs-theme', bsTheme);
        if (bsTheme == "dark") {
            themeMenu.children[0].classList.replace(prevCss, 'bi-moon-stars-fill');
        }
    }
    if (!themeMenu) return;

    document.querySelectorAll('[data-bs-theme-value]').forEach(value => {
        value.addEventListener('click', () => {
            const theme = value.getAttribute('data-bs-theme-value');
            const themeCss = value.getAttribute('data-bs-theme-style');
            themeMenu.children[0].classList.replace(prevCss, themeCss);
            localStorage.setItem("bsTheme", theme);
            prevCss = themeCss;
            document.documentElement.setAttribute('data-bs-theme', theme);
        });
    });
}

async function obtenerTituloDeUrl(url, idAttr) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            console.error(`Error al obtener la URL: ${response.status} ${response.statusText}`);
            return null;
        }
        const htmlText = await response.text();
        const parser = new DOMParser();
        const doc = parser.parseFromString(htmlText, 'text/html');
        const title = doc.title;
        //console.log(title);
        document.getElementById(idAttr).innerHTML = title;
        document.getElementById(idAttr).title = url + " ➤ " + title;
        return title || null;

    } catch (error) {
        document.getElementById(idAttr).style.display = 'none';
        console.error(`Ocurrió un error al procesar la URL '${url}':`, error);
        return null;
    }
}
function dataUrl(url, id) {
    obtenerTituloDeUrl(url, id).then(title => {
        if (!title) {
            console.log('No se pudo obtener el título de la URL inexistente (esperado).');
        }
    });
}
async function obtenerUptimeUrl(url, idAttr) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            console.error(`Error al obtener la URL: ${response.status} ${response.statusText}`);
            return null;
        }
        let responseJson = await response.json();
        let IDdatetime = 'datetime_' + idAttr;
        let IDdatabase = 'database_' + idAttr;
        let IDcache = 'cache_' + idAttr;
        let dataJson = responseJson.data;
        document.getElementById(IDcache).innerHTML = dataJson.cache.uptime;
        document.getElementById(IDcache).title = dataJson.cache.server.name + " Uptime ➤ " + dataJson.cache.uptime;
        document.getElementById(IDdatabase).innerHTML = dataJson.database.uptime;
        document.getElementById(IDdatabase).title = dataJson.database.server.name + " Uptime ➤ " + dataJson.database.uptime;
        document.getElementById(IDdatetime).innerHTML = dataJson.datetime;
        document.getElementById(IDdatetime).title = "DateTime ➤ " + dataJson.datetime;
        console.log('DateTime : ',  dataJson.datetime);
        return "dd";

    } catch (error) {
        // document.getElementById(idAttr).style.display = 'none';
        console.error(`Ocurrió un error al procesar la URL '${url}':`, error);
        return null;
    }
}
function dataUptimeUrl(url, id) {
    obtenerUptimeUrl(url, id).then(title => {
        if (!title) {
            console.log('No se pudo obtener el título de la URL inexistente (esperado).');
        }
    });
}

