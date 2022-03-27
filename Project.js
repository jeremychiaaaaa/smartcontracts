var myVar;

function time() {
    myVar = setTimeout(showPage, 3000)
    
}

function showPage() {
    document.getElementById('loading').style.display = 'none'
    document.getElementById('header').style.visibility = 'visible'
}

let header = document.getElementById('header')
window.onload = function(){
    setTimeout(showPage, 3000)
}
