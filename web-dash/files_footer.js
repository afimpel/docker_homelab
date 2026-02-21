fetch('https://bootswatch.com/api/5.json')
    .then(response => response.json())
    .then(data => load(data));
var selectTheme;
try {
    selectTheme = localStorage.getItem("selectTheme");
    if (selectTheme === null) {
        selectTheme = 8;
        localStorage.setItem("selectTheme", 8);
    }
} catch (error) {
    selectTheme = 8;
    console.error(error);
}

function load(data) {
    const themes = data.themes;
    const validIds = [25,24,22,21,20,18,16,15,11,8,7,5,1].sort((a, b) => a - b);
    const filteredThemes = validIds.map(id => themes[id]);
    const select = document.querySelector('#select_bootswatch');
    filteredThemes.forEach((value, index) => {
        const option = document.createElement('option');
        option.value = index;
        option.selected = (selectTheme == index) ? true : false;
        option.textContent = value.name;
        select.append(option);
    });

    select.addEventListener('change', (e) => {
        const theme = filteredThemes[e.target.value];
        localStorage.setItem("selectTheme", e.target.value);
        //select_bootswatch_www
        document.querySelector('#theme_bootswatch').setAttribute('href', theme.css);
        document.querySelector('#select_bootswatch_www').setAttribute('href', theme.preview);
        document.querySelector('#select_bootswatch_text').innerHTML=theme.name;
    });

    const changeEvent = new Event('change');
    select.dispatchEvent(changeEvent);
}