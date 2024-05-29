interface InventoryItem {
  _id: string
  title: string
  description: string
  images: string[]
  costPrice: number
  sellingPrice: number
  quantity: number
  listedAt: Date
}

export default InventoryItem
