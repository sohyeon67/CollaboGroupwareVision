function alertWarning(message) {
    Swal.fire({
        icon: 'warning',
        title: '경고',
        text: message
    });
}

function alertError(message) {
    Swal.fire({
        icon: 'error',
        title: '오류',
        text: message
    });
}

function alertSuccess(message) {
    Swal.fire({
        icon: 'success',
        title: '성공',
        text: message
    });
}