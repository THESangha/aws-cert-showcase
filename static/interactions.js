document.querySelectorAll(".links-tab-list").forEach(function (list) {
	const activeBackground = list.querySelector(".links-tab-active");
	const links = list.querySelectorAll("a");

	if (!activeBackground || links.length === 0) {
		return;
	}

	function moveActiveBackground(link) {
		activeBackground.style.left = `${link.offsetLeft}px`;
		activeBackground.style.top = `${link.offsetTop}px`;
		activeBackground.style.width = `${link.offsetWidth}px`;
		activeBackground.style.height = `${link.offsetHeight}px`;
	}

	const currentLink = list.querySelector("a.active") || links[0];
	moveActiveBackground(currentLink);

	links.forEach(function (link) {
		link.addEventListener("mouseenter", function () {
			moveActiveBackground(link);
		});
	});
});

document.addEventListener("click", function (event) {
	const toggle = event.target.closest(".button-container > .button");
	if (toggle) {
		const container = toggle.closest(".button-container");
		container.classList.toggle("active");
	}

	const icon = event.target.closest(".interactive-icon");
	if (icon) {
		icon.classList.remove("clicked");
		void icon.offsetWidth;
		icon.classList.add("clicked");
	}
});
