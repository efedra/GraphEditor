import React from 'react';
import TextField from '@material-ui/core/TextField';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';

export default function FormDialog() {
    const [open, setOpen] = React.useState(false);

    const handleClickOpen = () => {
        setOpen(true);
    };

    const handleClose = () => {
        setOpen(false);
    };

    return (
        <>
            <button
                className="bg-white-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 border border-blue-700 rounded float-right ml-1 mr-1 "
                onClick={handleClickOpen}>Invite
            </button>
            <Dialog open={open} onClose={handleClose} aria-labelledby="form-dialog-title">
                <div className=" text-blue-500 float-left mt-2" > <DialogTitle id="form-dialog-title">Subscribe</DialogTitle></div>
                <hr></hr>
                <DialogContent>
                    <DialogContentText>
                        To invite your friend to this graph, please enter friend's email address here. We will send invitation.
                    </DialogContentText>
                    <TextField
                        autoFocus
                        margin="dense"
                        id="name"
                        label="Email Address"
                        type="email"
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
                        onClick={handleClose} autoFocus >Submit
                    </button>
                </DialogActions>
            </Dialog>
        </>
    );
}