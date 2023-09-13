const ingredients = document
  .getElementById("data")
  .innerHTML.split("§§")
  .map((ingredient) => {
    const data = ingredient.split("§");
    return { id: data[0], name: [1], price: [2] };
  });

const order = localStorage.getItem("order") || [];