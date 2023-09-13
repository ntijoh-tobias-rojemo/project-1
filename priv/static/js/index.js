document.querySelectorAll("main > div").forEach((pizza) => {
  const data = `${pizza.dataset.id}§${pizza.dataset.name}§${pizza.dataset.ingredients}§${pizza.dataset.price}`;
  pizza.querySelector(".customize").addEventListener("click", () => {
    const order = localStorage.getItem("order")?.split("§§") || [];
    order.push(data);
    localStorage.setItem("order", order.join("§§"));

    location.assign("/cart");
  });

  pizza.querySelector(".buy").addEventListener("click", () => {
    const order = localStorage.getItem("order")?.split("§§") || [];
    order.push(data);
    localStorage.setItem("order", order.join("§§"));
  });
});
