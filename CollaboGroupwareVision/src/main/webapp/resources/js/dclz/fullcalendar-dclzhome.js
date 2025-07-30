/* DOM 콘텐츠가 완전히 로드되면 제공된 콜백 함수를 트리거하는 이벤트 리스너 */
document.addEventListener("DOMContentLoaded", () => {



    // Demo purpose - Set the event based on the current year and month.
    // 현재 날짜를 얻기 위해 Date 객체를 생성
    // currentYear와 currentMonth는 각각 현재 연도와 월을 저장
    // padStart 메서드는 월이 항상 두 자리 숫자임을 보장하기 위해 사용
    // ----------------------------------------------
    const today = new Date();
    const currentYear = today.getFullYear();
    const currentMonth = (today.getMonth() + 1).toString().padStart(2, "0");



    // Initialize the FullCalendar
    // ----------------------------------------------
    const calendar = new FullCalendar.Calendar(document.getElementById("_dm-calendar"), {
        timeZone: "UTC",
        editable: true,
        droppable: true, // this allows things to be dropped onto the calendar
        dayMaxEvents: true, // allow "more" link when too many events
        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth"
        },

        themeSystem: "bootstrap",

        bootstrapFontAwesome: {
            close: " demo-psi-cross",
            prev: " demo-psi-arrow-left",
            next: " demo-psi-arrow-right",
            prevYear: " demo-psi-arrow-left-2",
            nextYear: " demo-psi-arrow-right-2"
        },

        /* 화면에서 출력되는 일정이 있는 곳 */
        events: [],

    });







    const events = [
        {
            title: "근무",
            start: `${currentYear}-${currentMonth}-05`,
            end: `${currentYear}-${currentMonth}-07`,
            className: "bg-purple"
        },
        {
            title: "지각",
            start: `${currentYear}-${currentMonth}-15`,
            end: `${currentYear}-${currentMonth}-19`,
            className: "bg-secondary"
        },
        {
            title: "출장",
            start: `${currentYear}-${currentMonth}-15`,
            className: "bg-warning"
        },
        {
            title: "연차",
            start: `${currentYear}-${currentMonth}-20T10:30:00`,
            end: `${currentYear}-${currentMonth}-20T12:30:00`,
            className: "bg-danger text-white"
        },
        {
            title: "반차",
            start: `${currentYear}-${currentMonth + 1}-01`,
            className: "bg-warning"
        },
        {
            title: "병가",
            start: `${currentYear}-${currentMonth + 1}-07`,
            end: `${currentYear}-${currentMonth + 1}-10`,
            className: "bg-purple"
        },
        {
            id: 999,
            title: "결근",
            start: `${currentYear}-${currentMonth + 1}-09T16:00:00`
        }
    ]
    console.log(events);
    calendar.render();

});