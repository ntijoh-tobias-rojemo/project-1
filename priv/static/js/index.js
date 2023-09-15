const cart = document.querySelector(".basket img");

document.querySelectorAll("main > div").forEach((pizza) => {
  const data = `${pizza.dataset.id}§${pizza.dataset.name}§${pizza.dataset.ingredients}§${pizza.dataset.price}`;
  pizza.querySelector(".customize").addEventListener("click", () => {
    const order = localStorage.getItem("order")?.split("§§") || [];
    order.push(data);
    localStorage.setItem("order", order.join("§§"));
    location.assign(`/cart#${order.length - 1}`);
  });
  pizza.querySelector(".buy").addEventListener("click", () => {
    const order = localStorage.getItem("order")?.split("§§") || [];
    order.push(data);
    localStorage.setItem("order", order.join("§§"));
    cart.animate(
      [
        { transform: "translate(0, 0) rotate(0deg)" },
        { transform: "translate(5px, -15px) rotate(5deg)" },
        { transform: "translate(0, 0) rotate(0deg)" },
        { transform: "translate(-5px, -15px) rotate(-5deg)" },
        { transform: "translate(0, 0) rotate(0deg)" },
      ],
      {
        duration: 125,
        iterations: 2,
        easing: "ease-in-out",
        fill: "forwards",
      }
    );
  });
});
