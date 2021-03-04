import React from 'react';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import TextField from '@material-ui/core/TextField';

export default function AlertDialog() {
    const [open, setOpen] = React.useState(false);

    const handleClickOpen = () => {
        setOpen(true);
    };

    const handleClose = () => {
        setOpen(false);
    };
    const handleOpen=()=>{
        let that = this;
        fetch('/api/graphs/', {method: 'post'}).then(function (response) {

        })
        setOpen(false)
    }

    return (
        <div>
            <button
                className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded mb-2 ml-10  mt-2 "
                onClick={handleClickOpen}>+ Create
            </button>
            <Dialog
                open={open}
                onClose={handleClose}
                aria-labelledby="alert-dialog-title"
                aria-describedby="alert-dialog-description"
            >
                <div className=" text-blue-500 float-left mt-2">
                <DialogTitle id="alert-dialog-title">{"Create graph"}</DialogTitle>
                </div>
                <hr></hr>
                <DialogContent>
                    <DialogContentText id="alert-dialog-description">
                        Enter the name of the graph:
                    </DialogContentText>
                    <TextField
                        autoFocus
                        margin="dense"
                        id="name"
                        label="Name graph"
                        type="text"

                        fullWidth
                    />
                </DialogContent>
                <DialogActions>
                    <button
                        className="bg-white-500 text-red-500 hover:bg-red-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded  "
                        onClick={handleClose}>Cancel
                    </button>
                    <button
                        className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded "
                        onClick={handleOpen} autoFocus >Submit
                    </button>
                </DialogActions>
            </Dialog>
        </div>
    );
}