#!/opt/miniconda3/envs/pix2text/bin/python
# import sys
# from pix2text import Pix2Text, merge_line_texts
# p2t = Pix2Text()
# 
# def recog_merge(img_fp):
#     outs = p2t.recognize(img_fp, resized_shape=608)  # You can also use `p2t(img_fp)` to get the same result
#     # If you only need the recognized texts and LaTeX representations, use the following line of code to merge all results
#     only_text = merge_line_texts(outs, auto_line_break=True)
#     return only_text
# 
# def recog_tex(img_fp):
#     outs = p2t.recognize_formula(img_fp)
#     return outs
# 
# if __name__ == "__main__":
#     img_path = sys.argv[1]  # Get the image path from the command line arguments
#     result = recog_merge(img_path)
#     print(result)
import sys
import requests

url = 'https://pix2text.zoxi.org/pix2text'

def recognize_online(image_fp, type="mixed"):
    data = {
        "image_type": type,  # "mixed": Mixed image; "formula": Pure formula image; "text": Pure text image
        "resized_shape": 768,  # Effective only when image_type=="mixed"
        "embed_sep": " $,$ ",  # Effective only when image_type=="mixed"
        "isolated_sep": "\n$$\n, \n$$\n"  # Effective only when image_type=="mixed"
    }
    files = {
        "image": (image_fp, open(image_fp, 'rb'))
    }

    r = requests.post(url, data=data, files=files)

    outs = r.json()['results']
    if isinstance(outs, str):
        s = outs
    else:
        s = '\n'.join([out['text'] for out in outs])
    return s



if __name__ == "__main__":
    _type = sys.argv[1]
    img_path = sys.argv[2]  # Get the image path from the command line arguments
    
    result = recognize_online(img_path, _type)
    print(result)


