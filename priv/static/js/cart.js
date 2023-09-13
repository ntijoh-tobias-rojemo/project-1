const ingredients = document
  .getElementById("data")
  .innerHTML.split("§§")
  .map((ingredient) => {
    const data = ingredient.split("§");
    return { id: data[0], name: data[1], price: data[2] };
  });

const order =
  localStorage
    .getItem("order")
    ?.split("§§")
    ?.map((pizza) => {
      const data = pizza.split("§");
      return { id: data[0], name: data[1], ingredients: data[2], price: data[3] };
    }) || [];
