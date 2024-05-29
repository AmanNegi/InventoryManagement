import { LoaderCircle } from 'lucide-react'

const LoadingWidget = () => {
  return (
    <>
      <section className="h-[40vh] flex items-center justify-center">
        <LoaderCircle />
      </section>
    </>
  )
}

export default LoadingWidget
